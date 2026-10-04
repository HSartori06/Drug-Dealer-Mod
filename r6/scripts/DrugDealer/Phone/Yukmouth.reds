module DrugDealer.Phone

// -----------------------------------------------------------------------------
// Yukmouth - DrugDealer
// -----------------------------------------------------------------------------
import DrugDealer.State.{PlayerStateSystem, DrugDealerRank, TurfControlSystem, TurfLocation, Turf, GetCurrentTurf}
import DrugDealer.Spawn.EntitySpawnSystem
import DrugDealer.Job.{Job, JobSchedulerSystem, JobType}
import DrugDealer.Job.Raid.{RaidLocation, RaidJob, ConvertToRaidLocation}
import DrugDealer.Translation.TranslateTurfLocation
import DrugDealer.Job.SellDrugs.{BuyerLocation, SellDrugsJob, DemandPresets, DrugDemand, ConvertToBuyerLocation}
import DrugDealer.Research.{ResearchSystem, ResearchPreset, ResearchPresets}
import NightlyNow.Transaction.*
import NightlyNow.Notification.{NotificationSystem, NotificationStyle}
import NightlyNow.Holo.*
import DrugDealer.Settings.{Constants, SettingsSystem}

enum YukmouthOperation {
    Hello = 0,
    PlayerRaid = 1,
    PlayerRecipes = 2,
    PlayerStatus = 3,
    PlayerCancel = 4,
    YukmouthCancelConfirm = 5,
    YukmouthStatusReply = 6,
    YukmouthRaidWatsonReply = 7,
    YukmouthRaidSantoDomingoReply = 8,
    YukmouthRaidCooldown = 9,
    YukmouthRaidNoTurf = 10,
    PlayerSellDrugs = 11,
    YukmouthSellDrugsCooldown = 12,
    YukmouthSellDrugsNoTurf = 13,
    YukmouthBuyerWatsonReply = 14,
    YukmouthBuyerSantoDomingoReply = 15,
    YukmouthRecipesReply = 16,
    PlayerBigDrugDeal = 17,
    YukmouthBigDrugDealReply = 18,
    YukmouthJobCooldown = 19,
    PlayerCoordinates = 20,
    YukmouthCoordinatesReply = 21,
    YukmouthResearchOffer = 22,
    PlayerResearchAccept = 23,
    PlayerResearchDecline = 24,
    PlayerResearchBroke = 25,
    YukmouthResearchDone = 26,
    YukmouthResearchDeclineReply = 27,
    YukmouthResearchBrokeReply = 28,
    YukmouthRaidBadlandsReply = 29,
    YukmouthBuyerBadlandsReply = 30,
    YukmouthRaidWestbrookReply = 31,
    YukmouthBuyerWestbrookReply = 32,
    YukmouthBigDrugDealWhoReply = 33,
    PlayerBigDrugDealHighSocietyAttempt = 34,
    PlayerBigDrugDealCorposAttempt = 35,
    PlayerBigDrugDealEnemiesAttempt = 36,
    YukmouthBigDrugDealHighSocietyReject = 37,
    YukmouthBigDrugDealCorposReject = 38,
    YukmouthBigDrugDealEnemiesReject = 39,
    PlayerBigDrugDealCancel = 40,
    YukmouthBigDrugDealCancelReply = 41,
    YukmouthBigDrugDealHighSocietyReply = 42,
    YukmouthRaidWatsonTurfControlled = 43,
    YukmouthRaidSantoDomingoTurfControlled = 44,
    YukmouthRaidBadlandsTurfControlled = 45,
    YukmouthRaidWestbrookTurfControlled = 46,
    YukmouthBuyerHeywoodReply = 47,
    YukmouthRaidHeywoodReply = 48,
    YukmouthRaidHeywoodTurfControlled = 49,
    YukmouthBuyerPacificaReply = 50,
    YukmouthRaidPacificaReply = 51,
    YukmouthRaidPacificaTurfControlled = 52,
    MAX = 53,
}

public class YukmouthPhoneListener extends ContactHandler {
    private let player: wref<PlayerPuppet>;
    private let messengerController: wref<MessengerDialogViewController>;
    private let messageTree: array<DialogEntry>;

    public func Init(player: ref<PlayerPuppet>) {
        this.player = player;
        ArrayClear(this.messageTree);
        ArrayResize(this.messageTree, EnumInt(YukmouthOperation.MAX));
        // Hello text is set dynamically via random selection
        this.messageTree[EnumInt(YukmouthOperation.Hello)].viewType = MessageViewType.Received;
        this.messageTree[EnumInt(YukmouthOperation.YukmouthCancelConfirm)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthCancelConfirm");
        this.messageTree[EnumInt(YukmouthOperation.YukmouthCancelConfirm)].viewType = MessageViewType.Received;
        // YukmouthStatusReply text is set dynamically in HandlePlayerStatus
        this.messageTree[EnumInt(YukmouthOperation.YukmouthStatusReply)].viewType = MessageViewType.Received;
        // Yukmouth raid sub-conversation
        this.messageTree[EnumInt(YukmouthOperation.YukmouthRaidWatsonReply)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidWatsonReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidWatsonReply)]
            .viewType = MessageViewType.Received;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidSantoDomingoReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidSantoDomingoReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidSantoDomingoReply)]
            .viewType = MessageViewType.Received;
        this.messageTree[EnumInt(YukmouthOperation.YukmouthRaidCooldown)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidCooldown");
        this.messageTree[EnumInt(YukmouthOperation.YukmouthRaidCooldown)].viewType = MessageViewType.Received;
        this.messageTree[EnumInt(YukmouthOperation.YukmouthRaidNoTurf)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidNoTurf");
        this.messageTree[EnumInt(YukmouthOperation.YukmouthRaidNoTurf)].viewType = MessageViewType.Received;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidWatsonTurfControlled)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidWatsonTurfControlled");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidWatsonTurfControlled)]
            .viewType = MessageViewType.Received;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidSantoDomingoTurfControlled)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidSantoDomingoTurfControlled");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidSantoDomingoTurfControlled)]
            .viewType = MessageViewType.Received;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidBadlandsTurfControlled)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidBadlandsTurfControlled");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidBadlandsTurfControlled)]
            .viewType = MessageViewType.Received;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidWestbrookTurfControlled)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidWestbrookTurfControlled");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidWestbrookTurfControlled)]
            .viewType = MessageViewType.Received;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidHeywoodTurfControlled)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidHeywoodTurfControlled");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidHeywoodTurfControlled)]
            .viewType = MessageViewType.Received;
        // Player messages
        this.messageTree[EnumInt(YukmouthOperation.PlayerRaid)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerRaid");
        this.messageTree[EnumInt(YukmouthOperation.PlayerRaid)].viewType = MessageViewType.Sent;
        this.messageTree[EnumInt(YukmouthOperation.PlayerRaid)].isQuest = true;
        this.messageTree[EnumInt(YukmouthOperation.PlayerRecipes)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerRecipes");
        this.messageTree[EnumInt(YukmouthOperation.PlayerRecipes)].viewType = MessageViewType.Sent;
        this.messageTree[EnumInt(YukmouthOperation.PlayerStatus)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerStatus");
        this.messageTree[EnumInt(YukmouthOperation.PlayerStatus)].viewType = MessageViewType.Sent;
        this.messageTree[EnumInt(YukmouthOperation.PlayerCancel)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerCancel");
        this.messageTree[EnumInt(YukmouthOperation.PlayerCancel)].viewType = MessageViewType.Sent;
        // SellDrugs sub-conversation - player
        this.messageTree[EnumInt(YukmouthOperation.PlayerSellDrugs)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerSellDrugs");
        this.messageTree[EnumInt(YukmouthOperation.PlayerSellDrugs)].viewType = MessageViewType.Sent;
        this.messageTree[EnumInt(YukmouthOperation.PlayerSellDrugs)].isQuest = true;
        // SellDrugs sub-conversation - Yukmouth
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthSellDrugsCooldown)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthSellDrugsCooldown");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthSellDrugsCooldown)]
            .viewType = MessageViewType.Received;
        this.messageTree[EnumInt(YukmouthOperation.YukmouthSellDrugsNoTurf)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthSellDrugsNoTurf");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthSellDrugsNoTurf)]
            .viewType = MessageViewType.Received;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBuyerWatsonReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBuyerWatsonReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBuyerWatsonReply)]
            .viewType = MessageViewType.Received;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBuyerSantoDomingoReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBuyerSantoDomingoReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBuyerSantoDomingoReply)]
            .viewType = MessageViewType.Received;
        this.messageTree[EnumInt(YukmouthOperation.YukmouthRecipesReply)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRecipesReply");
        this.messageTree[EnumInt(YukmouthOperation.YukmouthRecipesReply)].viewType = MessageViewType.Received;
        // Big drug deal sub-conversation
        this.messageTree[EnumInt(YukmouthOperation.PlayerBigDrugDeal)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerBigDrugDeal");
        this.messageTree[EnumInt(YukmouthOperation.PlayerBigDrugDeal)].viewType = MessageViewType.Sent;
        this.messageTree[EnumInt(YukmouthOperation.PlayerBigDrugDeal)].isQuest = true;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBigDrugDealReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealReply)]
            .viewType = MessageViewType.Received;
        // Big drug deal - Yukmouth asks who to sell to
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealWhoReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBigDrugDealWhoReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealWhoReply)]
            .viewType = MessageViewType.Received;
        // Big drug deal - player choices
        this
            .messageTree[EnumInt(YukmouthOperation.PlayerBigDrugDealHighSocietyAttempt)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerBigDrugDealHighSocietyAttempt");
        this
            .messageTree[EnumInt(YukmouthOperation.PlayerBigDrugDealHighSocietyAttempt)]
            .viewType = MessageViewType.Sent;
        this
            .messageTree[EnumInt(YukmouthOperation.PlayerBigDrugDealCorposAttempt)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerBigDrugDealCorposAttempt");
        this
            .messageTree[EnumInt(YukmouthOperation.PlayerBigDrugDealCorposAttempt)]
            .viewType = MessageViewType.Sent;
        this
            .messageTree[EnumInt(YukmouthOperation.PlayerBigDrugDealEnemiesAttempt)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerBigDrugDealEnemiesAttempt");
        this
            .messageTree[EnumInt(YukmouthOperation.PlayerBigDrugDealEnemiesAttempt)]
            .viewType = MessageViewType.Sent;
        // Big drug deal - Yukmouth rejection replies
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealHighSocietyReject)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBigDrugDealHighSocietyReject");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealHighSocietyReject)]
            .viewType = MessageViewType.Received;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealCorposReject)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBigDrugDealCorposReject");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealCorposReject)]
            .viewType = MessageViewType.Received;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealEnemiesReject)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBigDrugDealEnemiesReject");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealEnemiesReject)]
            .viewType = MessageViewType.Received;
        // Big deal - player cancels
        this.messageTree[EnumInt(YukmouthOperation.PlayerBigDrugDealCancel)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerBigDrugDealCancel");
        this
            .messageTree[EnumInt(YukmouthOperation.PlayerBigDrugDealCancel)]
            .viewType = MessageViewType.Sent;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealCancelReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBigDrugDealCancelReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealCancelReply)]
            .viewType = MessageViewType.Received;
        // Big deal - high society reply
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealHighSocietyReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBigDrugDealHighSocietyReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealHighSocietyReply)]
            .viewType = MessageViewType.Received;
        // Job cooldown - too soon to schedule another job
        this.messageTree[EnumInt(YukmouthOperation.YukmouthJobCooldown)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthJobCooldown");
        this.messageTree[EnumInt(YukmouthOperation.YukmouthJobCooldown)].viewType = MessageViewType.Received;
        // Coordinates resend
        this.messageTree[EnumInt(YukmouthOperation.PlayerCoordinates)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerCoordinates");
        this.messageTree[EnumInt(YukmouthOperation.PlayerCoordinates)].viewType = MessageViewType.Sent;
        this.messageTree[EnumInt(YukmouthOperation.PlayerCoordinates)].isQuest = true;
        // YukmouthCoordinatesReply text is set dynamically in HandleCoordinates
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthCoordinatesReply)]
            .viewType = MessageViewType.Received;
        // Research sub-conversation - Yumouth messages (text set dynamically)
        this.messageTree[EnumInt(YukmouthOperation.YukmouthResearchOffer)].viewType = MessageViewType.Received;
        this.messageTree[EnumInt(YukmouthOperation.YukmouthResearchDone)].viewType = MessageViewType.Received;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthResearchDeclineReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthResearchDeclineReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthResearchDeclineReply)]
            .viewType = MessageViewType.Received;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthResearchBrokeReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthResearchBrokeReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthResearchBrokeReply)]
            .viewType = MessageViewType.Received;
        // Research sub-conversation - player messages
        this.messageTree[EnumInt(YukmouthOperation.PlayerResearchAccept)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerResearchAccept");
        this.messageTree[EnumInt(YukmouthOperation.PlayerResearchAccept)].viewType = MessageViewType.Sent;
        this.messageTree[EnumInt(YukmouthOperation.PlayerResearchDecline)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerResearchDecline");
        this.messageTree[EnumInt(YukmouthOperation.PlayerResearchDecline)].viewType = MessageViewType.Sent;
        this.messageTree[EnumInt(YukmouthOperation.PlayerResearchBroke)].content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.PlayerResearchBroke");
        this.messageTree[EnumInt(YukmouthOperation.PlayerResearchBroke)].viewType = MessageViewType.Sent;
        // Westbrook raid sub-conversation
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidWestbrookReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidWestbrookReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidWestbrookReply)]
            .viewType = MessageViewType.Received;
        // Badlands raid sub-conversation
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidBadlandsReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidBadlandsReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidBadlandsReply)]
            .viewType = MessageViewType.Received;
        // Heywood raid sub-conversation
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidHeywoodReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidHeywoodReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidHeywoodReply)]
            .viewType = MessageViewType.Received;
        // Westbrook buyer sub-conversation
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBuyerWestbrookReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBuyerWestbrookReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBuyerWestbrookReply)]
            .viewType = MessageViewType.Received;
        // Badlands buyer sub-conversation
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBuyerBadlandsReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBuyerBadlandsReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBuyerBadlandsReply)]
            .viewType = MessageViewType.Received;
        // Heywood buyer sub-conversation
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBuyerHeywoodReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBuyerHeywoodReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBuyerHeywoodReply)]
            .viewType = MessageViewType.Received;
        // Pacifica raid sub-conversation
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidPacificaReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidPacificaReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidPacificaReply)]
            .viewType = MessageViewType.Received;
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidPacificaTurfControlled)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthRaidPacificaTurfControlled");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthRaidPacificaTurfControlled)]
            .viewType = MessageViewType.Received;
        // Pacifica buyer sub-conversation
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBuyerPacificaReply)]
            .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBuyerPacificaReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBuyerPacificaReply)]
            .viewType = MessageViewType.Received;
    }

    // Yukmouth unique hash
    public func GetHash() -> Int32 = 29184223;

    // Yukmouth always at top
    public func AlwaysTop() -> Bool {
        let settingsSystem = SettingsSystem.Get();
        if !IsDefined(settingsSystem) {
            return false;
        }
        return settingsSystem.yukmouthPinned;
    }

    // Random hello message from pool
    private func GetRandomHelloText() -> String = GetLocalizedTextByKey(StringToName("DD.Yukmouth.Message.Hello" + ToString(RandRange(1, 105))));

    // Yukmouth contact name
    public func GetContactLocalizedName() -> String = GetLocalizedTextByKey(n"DD.Yukmouth.ContactName");

    // Yukmouth's contact data
    public func CreateContactData(forMessages: Bool) -> ref<ContactData> {
        let contactData: ref<ContactData>;
        contactData = new ContactData();
        contactData.hash = this.GetHash();
        contactData.localizedName = this.GetContactLocalizedName();
        contactData.contactId = s"Yukmouth";
        contactData.id = s"YukmouthSYS";
        contactData.avatarID = t"PhoneAvatars.Avatar_Unknown";
        let settingsSystem = SettingsSystem.Get();
        if !IsDefined(settingsSystem) {
            return null;
        }
        contactData.questRelated = settingsSystem.yukmouthPinned;
        contactData.isCallable = false;
        if forMessages {
            contactData.type = MessengerContactType.SingleThread;
            contactData.lastMesssagePreview = GetLocalizedTextByKey(n"DD.Yukmouth.Message.HelloPreview");
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

    public func OnDialogOpen(messenger: wref<MessengerDialogViewController>) -> Bool {
        this.messengerController = messenger;

        // First remove any lingering messages pushed by unresolved callbacks on previous dialog close
        this.messengerController.ClearMessages();
        this.messengerController.ClearReplies();

        this.messageTree[EnumInt(YukmouthOperation.Hello)].content = this.GetRandomHelloText();
        this.PushMessage(EnumInt(YukmouthOperation.Hello), false);

        this.messengerController.m_scrollController.SetScrollPosition(1.0);
        return true;
    }

    public func OnReplySelected(replyId: Int32) {
        this.messengerController.ClearReplies();
        this.PushMessage(replyId, false);

        switch replyId {
            case EnumInt(YukmouthOperation.PlayerRaid):
                this.HandleRaid();
                break;
            case EnumInt(YukmouthOperation.PlayerRecipes):
                this.HandlePlayerRecipes();
                break;
            case EnumInt(YukmouthOperation.PlayerBigDrugDeal):
                this.HandleBigDrugDeal();
                break;
            case EnumInt(YukmouthOperation.PlayerStatus):
                this.HandlePlayerStatus();
                break;
            case EnumInt(YukmouthOperation.PlayerCoordinates):
                this.HandleCoordinates();
                break;
            case EnumInt(YukmouthOperation.PlayerCancel):
                this.HandlePlayerCancel();
                break;
            case EnumInt(YukmouthOperation.PlayerSellDrugs):
                this.HandleSellDrugs();
                break;
            case EnumInt(YukmouthOperation.PlayerResearchAccept):
                this.HandleResearchAccept();
                break;
            case EnumInt(YukmouthOperation.PlayerResearchDecline):
                this.HandleResearchDecline();
                break;
            case EnumInt(YukmouthOperation.PlayerResearchBroke):
                this.HandleResearchBroke();
                break;
            case EnumInt(YukmouthOperation.PlayerBigDrugDealHighSocietyAttempt):
                this.HandleBigDrugDealHighSocietyAttempt();
                break;
            case EnumInt(YukmouthOperation.PlayerBigDrugDealCorposAttempt):
                this.HandleBigDrugDealCorposAttempt();
                break;
            case EnumInt(YukmouthOperation.PlayerBigDrugDealEnemiesAttempt):
                this.HandleBigDrugDealEnemiesAttempt();
                break;
            case EnumInt(YukmouthOperation.PlayerBigDrugDealCancel):
                this.HandleBigDrugDealCancel();
                break;
            default:
                return;
        }
    }

    // Maps raid location to its "turf controlled" message
    private func GetRaidTurfControlledMessage(raidLocation: RaidLocation) -> YukmouthOperation {
        switch raidLocation {
            case RaidLocation.Watson:
                return YukmouthOperation.YukmouthRaidWatsonTurfControlled;
            case RaidLocation.SantoDomingo:
                return YukmouthOperation.YukmouthRaidSantoDomingoTurfControlled;
            case RaidLocation.Westbrook:
                return YukmouthOperation.YukmouthRaidWestbrookTurfControlled;
            case RaidLocation.Badlands:
                return YukmouthOperation.YukmouthRaidBadlandsTurfControlled;
            case RaidLocation.Heywood:
                return YukmouthOperation.YukmouthRaidHeywoodTurfControlled;
            case RaidLocation.Pacifica:
                return YukmouthOperation.YukmouthRaidPacificaTurfControlled;
            default:
                return YukmouthOperation.YukmouthRaidWatsonTurfControlled;
        }
    }

    // Maps raid location to its reply message
    private func GetRaidReplyMessage(raidLocation: RaidLocation) -> YukmouthOperation {
        switch raidLocation {
            case RaidLocation.Watson:
                return YukmouthOperation.YukmouthRaidWatsonReply;
            case RaidLocation.SantoDomingo:
                return YukmouthOperation.YukmouthRaidSantoDomingoReply;
            case RaidLocation.Westbrook:
                return YukmouthOperation.YukmouthRaidWestbrookReply;
            case RaidLocation.Badlands:
                return YukmouthOperation.YukmouthRaidBadlandsReply;
            case RaidLocation.Heywood:
                return YukmouthOperation.YukmouthRaidHeywoodReply;
            case RaidLocation.Pacifica:
                return YukmouthOperation.YukmouthRaidPacificaReply;
            default:
                return YukmouthOperation.YukmouthRaidWatsonReply;
        }
    }

    // Maps raid location to its reply localization key
    private func GetRaidReplyLocalizationKey(raidLocation: RaidLocation) -> CName {
        switch raidLocation {
            case RaidLocation.Watson:
                return n"DD.Yukmouth.Message.YukmouthRaidWatsonReply";
            case RaidLocation.SantoDomingo:
                return n"DD.Yukmouth.Message.YukmouthRaidSantoDomingoReply";
            case RaidLocation.Westbrook:
                return n"DD.Yukmouth.Message.YukmouthRaidWestbrookReply";
            case RaidLocation.Badlands:
                return n"DD.Yukmouth.Message.YukmouthRaidBadlandsReply";
            case RaidLocation.Heywood:
                return n"DD.Yukmouth.Message.YukmouthRaidHeywoodReply";
            case RaidLocation.Pacifica:
                return n"DD.Yukmouth.Message.YukmouthRaidPacificaReply";
            default:
                return n"DD.Yukmouth.Message.YukmouthRaidWatsonReply";
        }
    }

    // Schedule a raid at player's current turf
    private func HandleRaid() {
        let scheduler = JobSchedulerSystem.Get();
        if !IsDefined(scheduler) {
            return;
        }

        // Active raid already running
        if !scheduler.CanScheduleJob(JobType.Raid) {
            this
                .TryPushDelayedMessage(
                    Constants.PhoneTypingDelay(),
                    EnumInt(YukmouthOperation.YukmouthRaidCooldown)
                );
            return;
        }

        // Too soon since last job finished
        if !scheduler.HasJobCooldownElapsed() {
            this
                .TryPushDelayedMessage(
                    Constants.PhoneTypingDelay(),
                    EnumInt(YukmouthOperation.YukmouthJobCooldown)
                );
            return;
        }

        // Player not in a raidable turf
        let raidedTurfLocation = GetCurrentTurf();
        if Equals(raidedTurfLocation, TurfLocation.None) {
            this
                .TryPushDelayedMessage(
                    Constants.PhoneTypingDelay(),
                    EnumInt(YukmouthOperation.YukmouthRaidNoTurf)
                );
            return;
        }
        let raidLocation = ConvertToRaidLocation(raidedTurfLocation);

        // Turf already controlled
        let turfControlSystem = TurfControlSystem.Get();
        if !IsDefined(turfControlSystem) {
            return;
        }
        let raidedTurf = turfControlSystem.GetTurf(raidedTurfLocation);
        if raidedTurf.IsControlled() {
            this
                .TryPushDelayedMessage(
                    Constants.PhoneTypingDelay(),
                    EnumInt(this.GetRaidTurfControlledMessage(raidLocation))
                );
            return;
        }

        // Possible player reinforcements
        let turfLocationWithReinforcements = turfControlSystem.GetEligibleReinforcementTurf(raidedTurfLocation);

        let params: array<Variant> = [ToVariant(raidLocation)];
        let raidJob = scheduler.ScheduleRaidJob(params);
        raidJob.Execute();
        raidJob.Navigate();

        // Append reinforcement message
        let replyOperation = this.GetRaidReplyMessage(raidLocation);
        let replyIndex = EnumInt(replyOperation);

        if !Equals(turfLocationWithReinforcements, TurfLocation.None) {
            // Pick random reinforcement flavor text
            let reinforcementKey = StringToName(
                "DD.Yukmouth.Message.RaidReinforcements" + ToString(RandRange(1, 49))
            );
            let reinforcementText = StrReplace(
                GetLocalizedTextByKey(reinforcementKey),
                "{0}",
                TranslateTurfLocation(turfLocationWithReinforcements)
            );

            let replyKey = this.GetRaidReplyLocalizationKey(raidLocation);
            this.messageTree[replyIndex].content = GetLocalizedTextByKey(replyKey) + "\n\n" + reinforcementText;
        }

        this
            .TryPushDelayedMessage(Constants.PhoneTypingDelay(), EnumInt(replyOperation));
    }

    // Maps buyer location to its reply message
    private func GetSellDrugsReplyMessage(buyerLocation: BuyerLocation) -> YukmouthOperation {
        switch buyerLocation {
            case BuyerLocation.Watson:
                return YukmouthOperation.YukmouthBuyerWatsonReply;
            case BuyerLocation.SantoDomingo:
                return YukmouthOperation.YukmouthBuyerSantoDomingoReply;
            case BuyerLocation.Westbrook:
                return YukmouthOperation.YukmouthBuyerWestbrookReply;
            case BuyerLocation.Badlands:
                return YukmouthOperation.YukmouthBuyerBadlandsReply;
            case BuyerLocation.Heywood:
                return YukmouthOperation.YukmouthBuyerHeywoodReply;
            case BuyerLocation.Pacifica:
                return YukmouthOperation.YukmouthBuyerPacificaReply;
            default:
                return YukmouthOperation.YukmouthBuyerWatsonReply;
        }
    }

    // Maps buyer location to its reply localization key
    private func GetSellDrugsReplyLocalizationKey(buyerLocation: BuyerLocation) -> CName {
        switch buyerLocation {
            case BuyerLocation.Watson:
                return n"DD.Yukmouth.Message.YukmouthBuyerWatsonReply";
            case BuyerLocation.SantoDomingo:
                return n"DD.Yukmouth.Message.YukmouthBuyerSantoDomingoReply";
            case BuyerLocation.Westbrook:
                return n"DD.Yukmouth.Message.YukmouthBuyerWestbrookReply";
            case BuyerLocation.Badlands:
                return n"DD.Yukmouth.Message.YukmouthBuyerBadlandsReply";
            case BuyerLocation.Heywood:
                return n"DD.Yukmouth.Message.YukmouthBuyerHeywoodReply";
            case BuyerLocation.Pacifica:
                return n"DD.Yukmouth.Message.YukmouthBuyerPacificaReply";
            default:
                return n"DD.Yukmouth.Message.YukmouthBuyerWatsonReply";
        }
    }

    // Schedule a street grade SellDrugs job at the player's current turf
    private func HandleSellDrugs() {
        let scheduler = JobSchedulerSystem.Get();
        if !IsDefined(scheduler) {
            return;
        }

        // Active sell job
        if !scheduler.CanScheduleJob(JobType.SellDrugs) {
            let activeJob = scheduler.FindActiveJobByType(JobType.SellDrugs) as SellDrugsJob;
            if IsDefined(activeJob) {
                let demandStr = activeJob.GetDrugDemand().ToString();
                let template = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthSellDrugsCooldown");
                this
                    .messageTree[EnumInt(YukmouthOperation.YukmouthSellDrugsCooldown)]
                    .content = StrReplace(template, "{0}", demandStr);
            }
            this
                .TryPushDelayedMessage(
                    Constants.PhoneTypingDelay(),
                    EnumInt(YukmouthOperation.YukmouthSellDrugsCooldown)
                );
            return;
        }

        // Too soon since last job finished
        if !scheduler.HasJobCooldownElapsed() {
            this
                .TryPushDelayedMessage(
                    Constants.PhoneTypingDelay(),
                    EnumInt(YukmouthOperation.YukmouthJobCooldown)
                );
            return;
        }

        // Player not on a valid turf
        let currentTurfLocation = GetCurrentTurf();
        if Equals(currentTurfLocation, TurfLocation.None) {
            this
                .TryPushDelayedMessage(
                    Constants.PhoneTypingDelay(),
                    EnumInt(YukmouthOperation.YukmouthSellDrugsNoTurf)
                );
            return;
        }
        let buyerLocation = ConvertToBuyerLocation(currentTurfLocation);

        let demand = DemandPresets.GetDrugDemandPreset();
        let params: array<Variant> = [ToVariant(buyerLocation), ToVariant(demand)];
        let sellDrugsJob = scheduler.ScheduleSellDrugsJob(params);
        sellDrugsJob.Execute();
        sellDrugsJob.Navigate();

        // Inject drug demand into reply message
        let replyOperation = this.GetSellDrugsReplyMessage(buyerLocation);
        let replyIndex = EnumInt(replyOperation);
        let replyKey = this.GetSellDrugsReplyLocalizationKey(buyerLocation);
        let demandStr = sellDrugsJob.GetDrugDemand().ToString();
        let template = GetLocalizedTextByKey(replyKey);
        this.messageTree[replyIndex].content = StrReplace(template, "{0}", demandStr);
        this.TryPushDelayedMessage(Constants.PhoneTypingDelay(), replyIndex);
    }

    // Check if new research is available
    private func HandlePlayerRecipes() {
        this.HandleResearch();
    }

    // Offer research if available, otherwise default reply
    private func HandleResearch() {
        let researchSystem = ResearchSystem.Get();
        if !IsDefined(researchSystem) {
            return;
        }
        let researchPreset = researchSystem.GetAvailableResearch();
        if !IsDefined(researchPreset) {
            this
                .TryPushDelayedMessage(
                    Constants.PhoneTypingDelay(),
                    EnumInt(YukmouthOperation.YukmouthRecipesReply)
                );
            return;
        }
        // Inject cost into research offer text
        let template = GetLocalizedTextByKey(researchPreset.research);
        this.messageTree[EnumInt(YukmouthOperation.YukmouthResearchOffer)].content = StrReplace(template, "{0}", IntToString(researchPreset.cost));
        this
            .TryPushDelayedMessage(
                Constants.PhoneTypingDelay(),
                EnumInt(YukmouthOperation.YukmouthResearchOffer)
            );
    }

    // Player accepts research - deduct money, unlock recipe
    private func HandleResearchAccept() {
        // Research system
        let researchSystem = ResearchSystem.Get();
        if !IsDefined(researchSystem) {
            return;
        }

        // Choose research preset
        let researchPreset = researchSystem.GetAvailableResearch();

        // Deduct money
        DeductMoney(researchPreset.cost);

        // Research the item
        researchSystem
            .Research(researchPreset.itemId, EnumInt(researchPreset.availableFromRank));

        // Enable looting materials for researched item
        researchSystem.EnableResearchedLoot();

        let notificationSystem = NotificationSystem.Get();
        if !IsDefined(notificationSystem) {
            return;
        }
        notificationSystem
            .ShowNotification(
                GetLocalizedTextByKey(n"DD.Research.Unlocked"),
                NotificationStyle.Research,
                1.0
            );
        this.messageTree[EnumInt(YukmouthOperation.YukmouthResearchDone)].content = GetLocalizedTextByKey(researchPreset.researchDone);
        this
            .TryPushDelayedMessage(
                Constants.PhoneTypingDelay(),
                EnumInt(YukmouthOperation.YukmouthResearchDone)
            );
    }

    // Player declines research
    private func HandleResearchDecline() {
        this
            .TryPushDelayedMessage(
                Constants.PhoneTypingDelay(),
                EnumInt(YukmouthOperation.YukmouthResearchDeclineReply)
            );
    }

    // Player can't afford research
    private func HandleResearchBroke() {
        this
            .TryPushDelayedMessage(
                Constants.PhoneTypingDelay(),
                EnumInt(YukmouthOperation.YukmouthResearchBrokeReply)
            );
    }

    // Yukmouth asks who to sell to for big deal
    private func HandleBigDrugDeal() {
        this
            .TryPushDelayedMessage(
                Constants.PhoneTypingDelay(),
                EnumInt(YukmouthOperation.YukmouthBigDrugDealWhoReply)
            );
    }

    // Player chose high society - check rank requirement
    private func HandleBigDrugDealHighSocietyAttempt() {
        let researchSystem = ResearchSystem.Get();
        if !IsDefined(researchSystem) {
            return;
        }
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }
        let playerRank = EnumInt(playerStateSystem.GetRank());

        let turfControlSystem = TurfControlSystem.Get();
        if !IsDefined(turfControlSystem) {
            return;
        }
        let westbrookTurf = turfControlSystem.GetTurf(TurfLocation.Westbrook);

        if playerRank
            >= EnumInt(DrugDealerRank.Supplier)
            && researchSystem.AnyPremiumDrugResearched()
            && westbrookTurf.IsControlled() {
            // Conditions for High society satisfied
            this.HandleBigDrugDealHighSociety();
        } else {
            this
                .TryPushDelayedMessage(
                    Constants.PhoneTypingDelay(),
                    EnumInt(YukmouthOperation.YukmouthBigDrugDealHighSocietyReject)
                );
        }
    }

    // Schedule a high society SellDrugs job
    private func HandleBigDrugDealHighSociety() {
        let jobSchedulerSystem = JobSchedulerSystem.Get();
        if !IsDefined(jobSchedulerSystem) {
            return;
        }

        // Check job cooldown
        if jobSchedulerSystem.CanScheduleJob(JobType.SellDrugs) && !jobSchedulerSystem.HasJobCooldownElapsed() {
            this
                .TryPushDelayedMessage(
                    Constants.PhoneTypingDelay(),
                    EnumInt(YukmouthOperation.YukmouthJobCooldown)
                );
            return;
        }

        if !jobSchedulerSystem.CanScheduleJob(JobType.SellDrugs) {
            // Inject drug demand info into cooldown message
            let activeJob = jobSchedulerSystem.FindActiveJobByType(JobType.SellDrugs) as SellDrugsJob;
            if IsDefined(activeJob) {
                let demandStr = activeJob.GetDrugDemand().ToString();
                let template = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthSellDrugsCooldown");
                this
                    .messageTree[EnumInt(YukmouthOperation.YukmouthSellDrugsCooldown)]
                    .content = StrReplace(template, "{0}", demandStr);
            }
            this
                .TryPushDelayedMessage(
                    Constants.PhoneTypingDelay(),
                    EnumInt(YukmouthOperation.YukmouthSellDrugsCooldown)
                );
            return;
        }

        let demand = DemandPresets.GetDrugDemandPreset(true);
        let params: array<Variant> = [
            ToVariant(BuyerLocation.WestbrookHighSociety),
            ToVariant(demand),
            ToVariant(true)
        ];

        // Execute the job
        let bigDrugDealHighSocietyJob = jobSchedulerSystem.ScheduleSellDrugsJob(params);
        bigDrugDealHighSocietyJob.Execute();
        bigDrugDealHighSocietyJob.Navigate();

        // Inject drug demand into reply message
        let demandStr = bigDrugDealHighSocietyJob.GetDrugDemand().ToString();
        let template = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthBigDrugDealHighSocietyReply");
        this
            .messageTree[EnumInt(YukmouthOperation.YukmouthBigDrugDealHighSocietyReply)]
            .content = StrReplace(template, "{0}", demandStr);
        this
            .TryPushDelayedMessage(
                Constants.PhoneTypingDelay(),
                EnumInt(YukmouthOperation.YukmouthBigDrugDealHighSocietyReply)
            );
    }

    // TODO Big drug deal selling to corpos
    private func HandleBigDrugDealCorposAttempt() {
        this
            .TryPushDelayedMessage(
                Constants.PhoneTypingDelay(),
                EnumInt(YukmouthOperation.YukmouthBigDrugDealCorposReject)
            );
    }

    // TODO Big drug deal selling to enemies
    private func HandleBigDrugDealEnemiesAttempt() {
        this
            .TryPushDelayedMessage(
                Constants.PhoneTypingDelay(),
                EnumInt(YukmouthOperation.YukmouthBigDrugDealEnemiesReject)
            );
    }

    // Player changed their mind about big deals
    private func HandleBigDrugDealCancel() {
        this
            .TryPushDelayedMessage(
                Constants.PhoneTypingDelay(),
                EnumInt(YukmouthOperation.YukmouthBigDrugDealCancelReply)
            );
    }

    private func HandlePlayerStatus() {
        let playerStateSystem = PlayerStateSystem.Get();
        if !IsDefined(playerStateSystem) {
            return;
        }
        this.messageTree[EnumInt(YukmouthOperation.YukmouthStatusReply)].content = playerStateSystem.GetRankDescription();
        this
            .TryPushDelayedMessage(
                Constants.PhoneTypingDelay(),
                EnumInt(YukmouthOperation.YukmouthStatusReply)
            );
    }

    private func HandlePlayerCancel() {
        this
            .TryPushDelayedMessage(
                Constants.PhoneTypingDelay(),
                EnumInt(YukmouthOperation.YukmouthCancelConfirm)
            );
    }

    // Resend coordinates for active job
    private func HandleCoordinates() {
        let scheduler = JobSchedulerSystem.Get();
        if !IsDefined(scheduler) {
            return;
        }
        let activeJob = scheduler.FindActiveJob();
        if IsDefined(activeJob) {
            activeJob.Navigate();
            this
                .messageTree[EnumInt(YukmouthOperation.YukmouthCoordinatesReply)]
                .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthCoordinatesFound");
        } else {
            this
                .messageTree[EnumInt(YukmouthOperation.YukmouthCoordinatesReply)]
                .content = GetLocalizedTextByKey(n"DD.Yukmouth.Message.YukmouthCoordinatesNoJob");
        }
        this
            .TryPushDelayedMessage(
                Constants.PhoneTypingDelay(),
                EnumInt(YukmouthOperation.YukmouthCoordinatesReply)
            );
    }

    private func GetTextWithParams(index: Int32) -> String {
        return this.messageTree[index].content;
    }

    private func PushMessage(index: Int32, playSound: Bool) {
        this
            .messengerController
            .AddMessage(
                this.GetTextWithParams(index),
                this.messageTree[index].viewType,
                this.GetContactLocalizedName(),
                playSound
            );
        switch index {
            case EnumInt(YukmouthOperation.Hello):
                this.PushReply(EnumInt(YukmouthOperation.PlayerSellDrugs), true);
                this.PushReply(EnumInt(YukmouthOperation.PlayerRaid), false);
                this.PushReply(EnumInt(YukmouthOperation.PlayerRecipes), false);
                this.PushReply(EnumInt(YukmouthOperation.PlayerBigDrugDeal), false);
                this.PushReply(EnumInt(YukmouthOperation.PlayerStatus), false);
                this.PushReply(EnumInt(YukmouthOperation.PlayerCoordinates), false);
                this.PushReply(EnumInt(YukmouthOperation.PlayerCancel), false);
                break;
            case EnumInt(YukmouthOperation.YukmouthBigDrugDealWhoReply):
                this
                    .PushReply(
                        EnumInt(YukmouthOperation.PlayerBigDrugDealHighSocietyAttempt),
                        true
                    );
                this
                    .PushReply(
                        EnumInt(YukmouthOperation.PlayerBigDrugDealCorposAttempt),
                        false
                    );
                this
                    .PushReply(
                        EnumInt(YukmouthOperation.PlayerBigDrugDealEnemiesAttempt),
                        false
                    );
                this
                    .PushReply(EnumInt(YukmouthOperation.PlayerBigDrugDealCancel), false);
                break;
            case EnumInt(YukmouthOperation.YukmouthResearchOffer):
                let researchSystem = ResearchSystem.Get();
                if !IsDefined(researchSystem) {
                    return;
                }
                let researchPreset = researchSystem.GetAvailableResearch();
                if IsDefined(researchPreset) && GetBalance() >= researchPreset.cost {
                    this
                        .PushReply(EnumInt(YukmouthOperation.PlayerResearchAccept), true);
                    this
                        .PushReply(EnumInt(YukmouthOperation.PlayerResearchDecline), false);
                } else {
                    this
                        .PushReply(EnumInt(YukmouthOperation.PlayerResearchBroke), true);
                }
                break;
            default:
                return;
        }
    }

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
// HUD Phone Controller hooks - register/unregister listener
// -----------------------------------------------------------------------------
@addField(NewHudPhoneGameController)
private let yukmouth: ref<YukmouthPhoneListener>;

@wrapMethod(NewHudPhoneGameController)
protected cb func OnInitialize() -> Bool {
    let result: Bool = wrappedMethod();

    let holoSystem = HoloSystem.Get(this.GetPlayerControlledObject());
    if !IsDefined(this.yukmouth) {
        this.yukmouth = new YukmouthPhoneListener();
        this.yukmouth.Init(this.GetPlayerControlledObject() as PlayerPuppet);
    }
    holoSystem.AddContact(this.yukmouth);
    return result;
}

@wrapMethod(NewHudPhoneGameController)
protected cb func OnUninitialize() -> Bool {
    let result: Bool = wrappedMethod();

    let holoSystem = HoloSystem.Get(this.GetPlayerControlledObject());
    holoSystem.RemoveContact(this.yukmouth);
    return result;
}

