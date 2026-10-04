module DrugDealer.Phone

// -----------------------------------------------------------------------------
// Shanice - DrugDealer
// -----------------------------------------------------------------------------
import NightlyNow.Holo.*
import DrugDealer.Settings.{SettingsSystem, Constants}
import DrugDealer.Job.JobSchedulerSystem
import DrugDealer.Job.Stash.{StashLocation, StashLocations, StashJob}
import DrugDealer.Operation.{OperationSystem, OperationResult, OperationType}

enum ShaniceOperation {
    InitialMessage = 0,
    MAX = 1,
}

public class ShanicePhoneListener extends ContactHandler {
    private let player: wref<PlayerPuppet>;
    private let messengerController: wref<MessengerDialogViewController>;
    private let messageTree: array<DialogEntry>;
    // Tracks which push message brought the player here (-1 = none)
    private let pendingMessage: Int32;

    public func Init(player: ref<PlayerPuppet>) {
        this.player = player;
        this.pendingMessage = -1;
        ArrayClear(this.messageTree);
        ArrayResize(this.messageTree, EnumInt(ShaniceOperation.MAX));
        this.messageTree[EnumInt(ShaniceOperation.InitialMessage)].content = GetLocalizedTextByKey(n"DD.Shanice.Message.Hello");
        this.messageTree[EnumInt(ShaniceOperation.InitialMessage)].viewType = MessageViewType.Received;
    }

    // Unique hash for Shanice
    public func GetHash() -> Int32 = 39271844;

    // Shanice contact name
    public func GetContactLocalizedName() -> String = GetLocalizedTextByKey(n"DD.Shanice.ContactName");

    // Shanice's contact data
    public func CreateContactData(forMessages: Bool) -> ref<ContactData> {
        let contactData = new ContactData();
        contactData.hash = this.GetHash();
        contactData.localizedName = this.GetContactLocalizedName();
        contactData.contactId = s"Shanice";
        contactData.id = s"ShaniceSYS";
        contactData.avatarID = t"PhoneAvatars.Avatar_Unknown";
        contactData.questRelated = false;
        contactData.isCallable = false;
        if forMessages {
            contactData.type = MessengerContactType.SingleThread;
            contactData.lastMesssagePreview = GetLocalizedTextByKey(n"DD.Shanice.Message.HelloPreview");
        } else {
            contactData.type = MessengerContactType.Contact;
        }
        contactData.messagesCount = 1;
        contactData.unreadMessegeCount = 1;
        ArrayInsert(contactData.unreadMessages, 0, 1);
        contactData.hasMessages = true;
        contactData.playerIsLastSender = false;
        contactData.playerCanReply = true;

        return contactData;
    }

    // Show the current message when the player opens the conversation
    public func OnDialogOpen(messenger: wref<MessengerDialogViewController>) -> Bool {
        this.messengerController = messenger;
        this.PushMessage(EnumInt(ShaniceOperation.InitialMessage), false);
        this.messengerController.m_scrollController.SetScrollPosition(1.0);
        return true;
    }

    public func OnReplySelected(replyId: Int32) {
        this.messengerController.ClearReplies();
        this.PushMessage(replyId, false);
    }

    public func CreateStashMessage(stashLocation: StashLocation) -> String {
        let locationName = StashLocations.StashLocationToString(stashLocation);

        // Pick a random stash message variant
        let key = StringToName("DD.Shanice.Message.NewStash" + ToString(RandRange(1, 19)));
        return StrReplace(GetLocalizedTextByKey(key), "{0}", locationName);
    }

    public func CreateFinancialReportMessage(operationResults: array<OperationResult>) -> String {
        if ArraySize(operationResults) == 0 {
            // Nothing to report
            return "";
        }

        let pushersRevenue = 0;
        let pushersCut = 0;
        let brothelsRevenue = 0;
        let brothelsCuts = 0;
        let totalProfit = 0;

        for operationResult in operationResults {
            totalProfit += operationResult.totalIncome;

            if Equals(OperationType.Pushers, operationResult.type) {
                // Pushers
                pushersRevenue += operationResult.totalIncome + operationResult.cut;
                pushersCut += operationResult.cut;
            }
            if Equals(OperationType.Brothel, operationResult.type) {
                // Brothels
                brothelsRevenue += operationResult.totalIncome + operationResult.cut;
                brothelsCuts += operationResult.cut;
            }
        }

        // Pushers
        let pushersLine = GetLocalizedTextByKey(n"DD.Shanice.Message.PushersNoRevenue");
        if pushersRevenue > 0 {
            pushersLine = StrReplace(
                GetLocalizedTextByKey(n"DD.Shanice.Message.PushersRevenue"),
                "{0}",
                s"\(pushersRevenue)"
            );
            pushersLine = StrReplace(pushersLine, "{1}", s"\(pushersCut)");
        }

        // Brothels
        let brothelsLine = GetLocalizedTextByKey(n"DD.Shanice.Message.BrothelsNoRevenue");
        if brothelsRevenue > 0 {
            brothelsLine = StrReplace(
                GetLocalizedTextByKey(n"DD.Shanice.Message.BrothelsRevenue"),
                "{0}",
                s"\(brothelsRevenue)"
            );
            brothelsLine = StrReplace(brothelsLine, "{1}", s"\(brothelsCuts)");
        }

        // Pick a random financial report message variant
        let key = StringToName("DD.Shanice.Message.FinancialReport" + ToString(RandRange(1, 4)));
        let msg = StrReplace(GetLocalizedTextByKey(key), "{0}", pushersLine);
        msg = StrReplace(msg, "{1}", brothelsLine);
        msg = StrReplace(msg, "{2}", s"\(totalProfit)");

        return msg;
    }

    // Set the conversation content and send a single push notification
    public func UpdateMessageAndNotify(content: String, pushKey: CName) {
        this.messageTree[EnumInt(ShaniceOperation.InitialMessage)].content = content;
        let phoneSystem = HoloSystem.Get(this.player);
        let pushMsg = GetLocalizedTextByKey(pushKey);
        phoneSystem
            .SendPushNotification(this.GetHash(), this.GetContactLocalizedName(), pushMsg);
    }

    // Reply handling will be added as message types grow
    // Called by JobScheduler to push a notification to the player
    public func SendPushNotification(messageID: Int32) {
        this.pendingMessage = messageID;
        let phoneSystem = HoloSystem.Get(this.player);
        let previewText = GetLocalizedTextByKey(n"DD.Shanice.Message.HelloPreview");
        phoneSystem
            .SendPushNotification(this.GetHash(), this.GetContactLocalizedName(), previewText);
    }

    private func PushMessage(index: Int32, playSound: Bool) {
        this
            .messengerController
            .AddMessage(
                this.messageTree[index].content,
                this.messageTree[index].viewType,
                this.GetContactLocalizedName(),
                playSound
            );
    }

    // Reply options will be added as message types grow
    private func PushReply(index: Int32, isSelected: Bool) {
        this
            .messengerController
            .AddReply(
                index,
                this.messageTree[index].content,
                this.messageTree[index].isQuest,
                isSelected,
                this.messengerController.m_hasFocus
            );
    }

    private func TryPushDelayedMessage(delay: Float, messageID: Int32) {
        if !this.PushDelayedMessage(delay, messageID) {
            this.PushMessage(messageID, true);
        }
    }

    public func OnTypingFinished(replyId: Int32) {
        this.messengerController.StopDotsAnimation();
        this.PushMessage(replyId, true);
    }

    private func PushDelayedMessage(delay: Float, messageID: Int32) -> Bool {
        if IsDefined(this.messengerController.m_delaySystem) && Constants.PhoneTypingDelay() > 0.0 {
            this.messengerController.ShowTypingDots(this.GetContactLocalizedName());
            this
                .QueueTypingDelay(this.messengerController.m_delaySystem, delay, messageID);
            return true;
        } else {
            return false;
        }
    }
}

// -----------------------------------------------------------------------------
// Shanice new stash callback
// -----------------------------------------------------------------------------
public class ShaniceNewStashPushCallback extends DelayCallback {
    public let controller: wref<NewHudPhoneGameController>;

    public func Call() {
        if IsDefined(this.controller) {
            this.controller.OnShanicePollTick();
        }
    }
}

// -----------------------------------------------------------------------------
// HUD Phone Controller hooks - register/unregister Shanice listener
// -----------------------------------------------------------------------------
@addField(NewHudPhoneGameController)
private let shanice: ref<ShanicePhoneListener>;

@addField(NewHudPhoneGameController)
private let shaniceCallbackDelayId: DelayID;

@wrapMethod(NewHudPhoneGameController)
protected cb func OnInitialize() -> Bool {
    let result: Bool = wrappedMethod();

    let holoSystem = HoloSystem.Get(this.GetPlayerControlledObject());
    if !IsDefined(this.shanice) {
        this.shanice = new ShanicePhoneListener();
        this.shanice.Init(this.GetPlayerControlledObject() as PlayerPuppet);
    }
    holoSystem.AddContact(this.shanice);

    // Start polling
    this.QueueNextPollingTick();
    return result;
}

@wrapMethod(NewHudPhoneGameController)
protected cb func OnUninitialize() -> Bool {
    let result: Bool = wrappedMethod();

    let holoSystem = HoloSystem.Get(this.GetPlayerControlledObject());
    holoSystem.RemoveContact(this.shanice);
    // Stops the polling
    this.StopShanicePolling();
    return result;
}

@addMethod(NewHudPhoneGameController)
private func QueueNextPollingTick() {
    let shaniceNewStashPushCallback = new ShaniceNewStashPushCallback();
    shaniceNewStashPushCallback.controller = this;
    let delaySystem = GameInstance.GetDelaySystem(this.GetPlayerControlledObject().GetGame());
    this.shaniceCallbackDelayId = delaySystem
        .DelayCallback(shaniceNewStashPushCallback, Constants.ShanicePollingInSeconds(), false);
}

@addMethod(NewHudPhoneGameController)
public func OnShanicePollTick() {
    let stashMessage = ExecuteShashLogic(this.shanice);
    let reportMessage = ExecuteStreetOperationsLogic(this.shanice);

    let receivedStash = StrLen(stashMessage) > 0;
    let receivedReport = StrLen(reportMessage) > 0;

    if receivedStash && receivedReport {
        // Gotta unify this so they don't overlap each other when they arrive at the same time
        this
            .shanice
            .UpdateMessageAndNotify(
                stashMessage + "\n\n" + reportMessage,
                n"DD.Shanice.Message.StashAndReportPush"
            );
    } else if receivedStash {
        this
            .shanice
            .UpdateMessageAndNotify(stashMessage, n"DD.Shanice.Message.NewStashPush");
    } else if receivedReport {
        this
            .shanice
            .UpdateMessageAndNotify(reportMessage, n"DD.Shanice.Message.FinancialReportPush");
    }

    // Queue next tick
    this.QueueNextPollingTick();
}

public func ExecuteStreetOperationsLogic(shanice: ref<ShanicePhoneListener>) -> String {
    let operationSystem = OperationSystem.Get();
    if !IsDefined(operationSystem) {
        return "";
    }
    let settings = SettingsSystem.Get();
    if !IsDefined(settings) {
        return "";
    }

    // Cash out the player
    operationSystem.CashOutPlayer();

    let message = "";
    if settings.financialReportEnabled {
        // Financial report with the usual abuse
        message = shanice
            .CreateFinancialReportMessage(operationSystem.GetPendingOperationResults());
    }

    // Clear the processed operation results
    operationSystem.ClearPeandingOperationResults();
    return message;
}

public func ExecuteShashLogic(shanice: ref<ShanicePhoneListener>) -> String {
    // Stash section
    let jobSchedulerSystem = JobSchedulerSystem.Get();
    if !IsDefined(jobSchedulerSystem) {
        return "";
    }

    // Roll random stash location
    let stashLocation = StashLocations.GetRandomStashLocation();
    let stashJob = jobSchedulerSystem.ScheduleStashJob([ToVariant(stashLocation)]);
    if IsDefined(stashJob) {
        // Spawn a new stash
        stashJob.Execute();
        // Create the message for the player
        let message = shanice.CreateStashMessage(stashLocation);
        // Navigate to stash
        stashJob.Navigate();
        return message;
    }
    return "";
}

// Cancel pending polling callback
@addMethod(NewHudPhoneGameController)
private func StopShanicePolling() {
    let delaySystem = GameInstance.GetDelaySystem(this.GetPlayerControlledObject().GetGame());
    delaySystem.CancelDelay(this.shaniceCallbackDelayId);
}

