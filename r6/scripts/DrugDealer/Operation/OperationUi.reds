module DrugDealer.Operation

import Codeware.UI.*
import DrugDealer.Settings.{Colors, SettingsSystem}
import DrugDealer.Settings.Constants
import DrugDealer.Market.MarketSystem
import NightlyNow.Utils.{FormatCurrency, IsCorpo}

// -----------------------------------------------------------------------------
// OperationUi - Drug Dealer
// Credit for the logic goes to DigitalVixen. You'z the best, mama.
// -----------------------------------------------------------------------------
public abstract class OperationUiMenuPopup extends CustomPopup {
    protected let m_vignette: wref<inkImage>;
    protected let m_background: wref<inkRectangle>;
    protected let m_container: wref<inkCompoundWidget>;

    protected cb func OnCreate() {
        super.OnCreate();
        this.CreateVignette();
        this.CreateContainer();
    }

    protected func CreateVignette() {
        let background: ref<inkRectangle> = new inkRectangle();
        background.SetName(n"dd_bg_rect");
        background.SetTintColor(HDRColor(0.054902, 0.054902, 0.090196, 1.0));
        background.SetSize(3840.0, 2160.0);
        background.SetAnchor(inkEAnchor.Centered);
        background.SetAnchorPoint(Vector2(0.5, 0.5));
        background.Reparent(this.GetRootCompoundWidget());

        let vignette: ref<inkImage> = new inkImage();
        vignette.SetName(n"dd_vignette");
        vignette
            .SetAtlasResource(r"base\\gameplay\\gui\\widgets\\notifications\\vignette.inkatlas");
        vignette.SetTexturePart(n"vignette_1");
        vignette.SetNineSliceScale(true);
        vignette.SetTintColor(ThemeColors.Bittersweet());
        vignette.SetOpacity(0.9);
        vignette.SetSize(32.0, 32.0);
        vignette.SetAnchor(inkEAnchor.CenterFillHorizontaly);
        vignette.SetAnchorPoint(Vector2(0.5, 0.5));
        vignette.SetHAlign(inkEHorizontalAlign.Center);
        vignette.SetVAlign(inkEVerticalAlign.Center);
        vignette.SetFitToContent(true);
        vignette.Reparent(this.GetRootCompoundWidget());

        this.m_background = background;
        this.m_vignette = vignette;
    }

    protected func CreateContainer() {
        let container: ref<inkCanvas> = new inkCanvas();
        container.SetName(n"dd_container");
        container.SetMargin(inkMargin(-30.0, 0.0, 0.0, 0.0));
        container.SetAnchor(inkEAnchor.Centered);
        container.SetAnchorPoint(Vector2(0.5, 0.5));
        container.SetSize(Vector2(3600.0, 1800.0));
        container.Reparent(this.GetRootCompoundWidget());

        this.m_container = container;
        this.SetContainerWidget(container);
    }

    protected cb func OnShow() {
        let alphaAnim: ref<inkAnimTransparency> = new inkAnimTransparency();
        alphaAnim.SetStartTransparency(0.0);
        alphaAnim.SetEndTransparency(1.0);
        alphaAnim.SetType(inkanimInterpolationType.Linear);
        alphaAnim.SetMode(inkanimInterpolationMode.EasyIn);
        alphaAnim.SetDuration(0.05);

        let animDef: ref<inkAnimDef> = new inkAnimDef();
        animDef.AddInterpolator(alphaAnim);

        this.m_transitionAnimProxy = this.m_container.PlayAnimation(animDef);
        this
            .m_transitionAnimProxy
            .RegisterToCallback(inkanimEventType.OnFinish, this, n"OnShowFinish");

        this.SetUIContext();
        this.SetBackgroundBlur();
        this.PlayShowSound();
    }

    protected cb func OnHide() {
        let alphaAnim: ref<inkAnimTransparency> = new inkAnimTransparency();
        alphaAnim.SetStartTransparency(1.0);
        alphaAnim.SetEndTransparency(0.0);
        alphaAnim.SetType(inkanimInterpolationType.Linear);
        alphaAnim.SetMode(inkanimInterpolationMode.EasyIn);
        alphaAnim.SetDuration(0.25);

        let animDef: ref<inkAnimDef> = new inkAnimDef();
        animDef.AddInterpolator(alphaAnim);

        this.m_transitionAnimProxy = this.m_container.PlayAnimation(animDef);
        this
            .m_transitionAnimProxy
            .RegisterToCallback(inkanimEventType.OnFinish, this, n"OnHideFinish");

        this.ResetUIContext();
        this.ResetBackgroundBlur();
        this.PlayHideSound();
    }

    public func Close() {
        this.CallCustomCallback(n"OnClose");
        super.Close();
    }

    protected func SetBackgroundBlur() {
        PopupStateUtils.SetBackgroundBlur(this.m_gameController, true);
    }

    protected func ResetBackgroundBlur() {
        PopupStateUtils.SetBackgroundBlur(this.m_gameController, false);
    }

    protected func SetUIContext() {
        let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.GetGame());
        uiSystem.PushGameContext(UIGameContext.ModalPopup);
        uiSystem.RequestNewVisualState(n"inkInGameMenuState");
    }

    protected func ResetUIContext() {
        let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.GetGame());
        uiSystem.PopGameContext(UIGameContext.ModalPopup);
        uiSystem.RestorePreviousVisualState(n"inkInGameMenuState");
    }

    protected func PlayShowSound() {
        this.PlaySound(n"Button", n"OnPress");
    }

    protected func PlayHideSound() {
        this.PlaySound(n"GameMenu", n"OnOpen");
    }
}

public class OperationUiPopup extends OperationUiMenuPopup {
    protected let m_header: ref<InGamePopupHeader>;
    protected let m_footer: ref<InGamePopupFooter>;
    protected let m_content: ref<InGamePopupContent>;
    protected let m_workbench: ref<OperationUiWorkbench>;

    public func Open(requester: wref<inkGameController>) {
        super.Open(requester);
    }

    protected cb func OnCreate() {
        super.OnCreate();

        this.m_header = InGamePopupHeader.Create();
        this.m_header.SetTitle(GetLocalizedTextByKey(n"DD.Operation.Report.Title"));
        this
            .m_header
            .SetFluffRight(GetLocalizedTextByKey(n"DD.Settings.System.Name"));
        this.m_header.Reparent(this);

        this.m_footer = InGamePopupFooter.Create();
        this.m_footer.SetFluffIcon(n"fluff_triangle2");
        this
            .m_footer
            .SetFluffText(GetLocalizedTextByKey(n"DD.Operation.Report.Title"));
        this.m_footer.Reparent(this);

        this.m_content = InGamePopupContent.Create();
        this.m_content.Reparent(this);

        this.m_workbench = OperationUiWorkbench.Create();
        this.m_workbench.SetSize(this.m_content.GetSize());
        this.m_workbench.Reparent(this.m_content);

        let statList: ref<OperationUiStatList> = new OperationUiStatList();
        this.m_workbench.AddContentComponent(statList);
        statList.CreateStats();
    }

    protected cb func OnInitialize() {
        super.OnInitialize();
    }

    public func UseCursor() -> Bool = true;

    protected cb func OnShown() {
    }
}

public class OperationUiWorkbench extends inkCustomController {
    protected let m_root: wref<inkFlex>;
    protected let m_container: wref<inkCanvas>;
    protected let m_areaSize: Vector2;

    protected cb func OnCreate() {
        let workbench: ref<inkFlex> = new inkFlex();
        workbench.SetName(n"dd_workbench");
        workbench.SetAnchor(inkEAnchor.Fill);

        let background: ref<inkRectangle> = new inkRectangle();
        background.SetAnchor(inkEAnchor.Fill);
        background.SetMargin(inkMargin(8.0, 8.0, 8.0, 8.0));
        background.SetTintColor(ThemeColors.PureBlack());
        background.SetOpacity(0.4);
        background.Reparent(workbench);

        let pattern: ref<inkImage> = new inkImage();
        pattern.SetName(n"dd_pattern");
        pattern
            .SetAtlasResource(r"base\\gameplay\\gui\\fullscreen\\inventory\\atlas_inventory.inkatlas");
        pattern.SetTexturePart(n"no_preview_grid");
        pattern.SetBrushTileType(inkBrushTileType.Both);
        pattern.SetTileHAlign(inkEHorizontalAlign.Center);
        pattern.SetTileVAlign(inkEVerticalAlign.Center);
        pattern.SetAnchor(inkEAnchor.Fill);
        pattern.SetOpacity(0.1);
        pattern.SetTintColor(ThemeColors.Bittersweet());
        pattern.SetMargin(inkMargin(8.0, 4.0, 8.0, 2.0));
        pattern.Reparent(workbench);

        let frame: ref<inkImage> = new inkImage();
        frame.SetName(n"dd_frame");
        frame
            .SetAtlasResource(r"base\\gameplay\\gui\\fullscreen\\inventory\\inventory4_atlas.inkatlas");
        frame.SetTexturePart(n"itemGridFrame3Big");
        frame.SetNineSliceScale(true);
        frame.SetNineSliceGrid(inkMargin(24.0, 24.0, 24.0, 24.0));
        frame.SetAnchor(inkEAnchor.Fill);
        frame.SetOpacity(0.5);
        frame.SetTintColor(ThemeColors.Bittersweet());
        frame.Reparent(workbench);

        let container: ref<inkCanvas> = new inkCanvas();
        container.SetName(n"dd_container");
        container.SetAnchor(inkEAnchor.Fill);
        container.Reparent(workbench);

        this.m_root = workbench;
        this.m_container = container;

        this.SetRootWidget(workbench);
        this.SetContainerWidget(container);
    }

    public func GetContainer() -> wref<inkCanvas> = this.m_container;

    public func GetSize() -> Vector2 = this.m_areaSize;

    public func SetSize(areaSize: Vector2) {
        this.m_areaSize = areaSize;
    }

    public func AddContentComponent(statsComponent: ref<OperationUiContentComponent>) {
        statsComponent.Assign(this);
    }

    public static func Create() -> ref<OperationUiWorkbench> {
        let self: ref<OperationUiWorkbench> = new OperationUiWorkbench();
        self.CreateInstance();
        return self;
    }
}

public abstract class OperationUiContentComponent extends inkCustomController {
    protected let m_name: String;
    protected let m_bench: wref<OperationUiWorkbench>;
    protected let m_container: wref<inkCanvas>;

    protected cb func OnAssign() {
        let namespace: String;
        StrSplitLast(NameToString(this.GetClassName()), ".", namespace, this.m_name);
    }

    protected cb func OnCreate() {
        let root: ref<inkCanvas> = new inkCanvas();
        root.SetName(this.GetClassName());
        root.SetAnchor(inkEAnchor.Fill);
        this.SetRootWidget(root);
    }

    protected func GetAreaSize() -> Vector2 = this.m_bench.GetSize();

    public func Assign(bench: ref<OperationUiWorkbench>) {
        this.m_bench = bench;
        this.m_container = this.m_bench.GetContainer();
        this.OnAssign();
        this.Reparent(this.m_bench);
    }
}

public class OperationUiStatList extends OperationUiContentComponent {
    protected let m_root: wref<inkFlex>;
    protected let m_list: wref<inkVerticalPanel>;
    protected let m_fontSize: Int32;

    protected cb func OnCreate() {
        let root: ref<inkFlex> = new inkFlex();
        root.SetName(this.GetClassName());
        root.SetAnchor(inkEAnchor.LeftFillVerticaly);
        root.SetMargin(0.0, 100.0, 100.0, 0.0);

        let list: ref<inkVerticalPanel> = new inkVerticalPanel();
        list.SetName(n"dd_stats_list");
        list.SetAnchor(inkEAnchor.Fill);
        list.SetOpacity(1.0);
        list.SetFitToContent(true);
        list.Reparent(root);

        this.m_root = root;
        this.m_list = list;

        this.SetRootWidget(root);
    }

    public func CreateStats() {
        this.m_fontSize = 35;

        this.AddTopLine(GetLocalizedTextByKey(n"DD.Operation.Report.TopLine"));
        this.AddColumnsTitle();
        this.AddData();
        this.AddBottomLine();
    }

    private func AddTopLine(title: String) {
        let text: ref<inkText> = new inkText();
        text.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        text.SetFontStyle(n"Medium");
        text.SetFontSize(50);
        text.SetLetterCase(textLetterCase.UpperCase);
        text.SetMargin(30.0, 0.0, 0.0, 0.0);
        text.SetTintColor(ThemeColors.Bittersweet());
        text.SetText(title);
        text.Reparent(this.m_list);

        let line: ref<inkRectangle> = new inkRectangle();
        line.SetSize(800.0, 3.0);
        line.SetTintColor(HDRColor(0.266667, 0.086275, 0.078431, 1.0));
        line.SetOpacity(1.0);
        line.SetMargin(30.0, 10.0, -900.0, 10.0);
        line.Reparent(this.m_list);
    }

    private func AddColumnsTitle() {
        let fontSize: Int32 = this.m_fontSize;
        let row: ref<inkCanvas> = new inkCanvas();
        let headerHeight: Float = Cast<Float>(fontSize) * 1.9;
        let headerMargin: Float = Cast<Float>(fontSize) * 0.31;
        row.SetSize(3200.0, headerHeight);
        row.SetMargin(30.0, headerMargin, 0.0, headerMargin);
        row.Reparent(this.m_list);

        let incomeColumnText = GetLocalizedTextByKey(n"DD.Operation.Report.Column.Income");
        if IsCorpo() {
            incomeColumnText = s"\(incomeColumnText) | \(GetLocalizedTextByKey(n"DD.Lifepath.Corpo"))";
        }

        this
            .AddHeaderCell(row, GetLocalizedTextByKey(n"DD.Operation.Report.Column.Turf"), 100.0);
        this
            .AddHeaderCell(
                row,
                GetLocalizedTextByKey(n"DD.Operation.Report.Column.Operator"),
                600.0
            );
        this
            .AddHeaderCell(
                row,
                GetLocalizedTextByKey(n"DD.Operation.Report.Column.Operation"),
                1100.0
            );
        this
            .AddHeaderCell(
                row,
                GetLocalizedTextByKey(n"DD.Operation.Report.Column.Status"),
                1600.0
            );
        this
            .AddHeaderCell(
                row,
                GetLocalizedTextByKey(n"DD.Operation.Report.Column.Supply"),
                2100.0
            );
        this.AddHeaderCell(row, incomeColumnText, 2600.0);
    }

    // Add organized crime data based on street operations
    private func AddData() {
        let settings = SettingsSystem.Get();
        if !IsDefined(settings) {
            return;
        }
        let operationSystem = OperationSystem.Get();
        if !IsDefined(operationSystem) {
            return;
        }
        let marketSystem = MarketSystem.Get();
        if !IsDefined(marketSystem) {
            return;
        }

        // Dimensions
        let rowHeight: Float = Cast<Float>(this.m_fontSize) * 1.43;
        let rowMargin: Float = Cast<Float>(this.m_fontSize) * 0.24;

        // Is to be displayed in the summary as a last row
        let totalDailyIncome = 0;

        // Used for bottom row
        let anyOperationActive: Bool;
        // Street operations data
        for operation in operationSystem.GetOperations() {
            if !anyOperationActive && operation.IsActive() {
                anyOperationActive = true;
            }

            if operation.IsActive() {
                totalDailyIncome += operation.GetEstimatedDailyIncome(marketSystem, settings);
            }

            let row: ref<inkCanvas> = new inkCanvas();
            row.SetSize(3200.0, rowHeight);
            row.SetMargin(30.0, rowMargin, 0.0, rowMargin);
            row.Reparent(this.m_list);

            let brothelBoosted = Equals(OperationType.Brothel, operation.type) && operation.IsSuppliedWithJoytoysKiss();

            let turf = operation.GetTurfLocalization();
            let operatedBy = operation.GetOrganizationLocalization();
            let type = operation.GetTypeLocalization();
            let status = operation.GetStatusLocalization();
            let supply = s"\(operation.GetSupplyInPercents())%";
            let dailyIncome = FormatCurrency(operation.GetEstimatedDailyIncome(marketSystem, settings))
                + (brothelBoosted ? s" (\(GetLocalizedTextByKey(n"DD.Operation.Report.BrothelBoosted")))" : "");

            this.AddDataCell(row, turf, 100.0, operation.GetTurfLocationColor());
            this.AddDataCell(row, operatedBy, 600.0, operation.GetTurfLocationColor());
            this.AddDataCell(row, type, 1100.0, operation.GetTypeColor());
            this.AddDataCell(row, status, 1600.0, operation.GetStatusColor());
            this.AddDataCell(row, supply, 2100.0, operation.GetSupplyColor());
            this.AddDataCell(row, dailyIncome, 2600.0, operation.GetDailyIncomeColor());
        }

        // Bottom line
        let row: ref<inkCanvas> = new inkCanvas();
        row.SetSize(3200.0, rowHeight);
        row.SetMargin(30.0, rowMargin, 0.0, rowMargin);
        row.Reparent(this.m_list);

        let totalDailyIncomeColor = anyOperationActive && totalDailyIncome > 0 ? ThemeColors.LightGreen() : Colors.Gray();
        this
            .AddDataCell(
                row,
                FormatCurrency(totalDailyIncome),
                /* Bold text too chunky */ 2597.0,
                totalDailyIncomeColor,
                true
            );
    }

    // Bottom summary
    private func AddBottomLine() {
        let line: ref<inkRectangle> = new inkRectangle();
        line.SetSize(480.0, 3.0);
        line.SetTintColor(HDRColor(0.266667, 0.086275, 0.078431, 1.0));
        line.SetOpacity(1.0);
        line.SetMargin(30.0, 10.0, 10.0, 30.0);
        line.Reparent(this.m_list);
    }

    private func AddHeaderCell(row: ref<inkCompoundWidget>, text: String, marginLeft: Float) {
        let cell: ref<inkText> = new inkText();
        cell.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        cell.SetFontStyle(n"Semi-Bold");
        cell.SetFontSize(this.m_fontSize);
        cell.SetMargin(marginLeft, 0.0, 0.0, 0.0);
        cell.SetHorizontalAlignment(textHorizontalAlignment.Left);
        cell.SetVerticalAlignment(textVerticalAlignment.Top);
        cell.SetHAlign(inkEHorizontalAlign.Left);
        cell.SetTintColor(ThemeColors.ElectricBlue());
        cell.SetText(text);
        cell.Reparent(row);
    }

    private func AddDataCell(
        row: ref<inkCompoundWidget>,
        text: String,
        marginLeft: Float,
        color: HDRColor,
        opt bold: Bool
    ) {
        let cell: ref<inkText> = new inkText();
        cell.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        cell.SetFontStyle(bold ? n"Semi-Bold" : n"Regular");
        cell.SetFontSize(this.m_fontSize);
        cell.SetMargin(marginLeft, 0.0, 0.0, 0.0);
        cell.SetHorizontalAlignment(textHorizontalAlignment.Left);
        cell.SetVerticalAlignment(textVerticalAlignment.Top);
        cell.SetHAlign(inkEHorizontalAlign.Left);
        cell.SetTintColor(color);
        cell.SetText(text);
        cell.Reparent(row);
    }
}

// hub menu button sits below Map
public class OperationUiOpenPopupEvent extends Event {
}

@addField(MenuHubLogicController)
private let m_operationUiBtn: wref<inkWidget>;

@wrapMethod(MenuHubLogicController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    if !IsDefined(root) {
        return true;
    }

    let container: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"mainMenu/buttonsContainer") as inkCompoundWidget;
    if !IsDefined(container) {
        return true;
    }

    let buttonWidget: ref<inkWidget> = this.SpawnFromLocal(container, n"menu_button");
    if !IsDefined(buttonWidget) {
        return true;
    }

    // If NCR is detected, apply auto-offset to be compatible right off the bat, also the DD settings offset is applied   
    let settings = SettingsSystem.Get();
    let operationButtonYOffset = IsDefined(settings) ? settings.operationUiYOffset : 0.0;
    ApplyButtonMargins(buttonWidget, operationButtonYOffset);

    let data: MenuData;
    data.identifier = Constants.OperationUiDataIdentifier();
    data.parentIdentifier = 4;
    data.label = GetLocalizedTextByKey(n"DD.Operation.Report.Title");
    data.icon = n"ico_journal";

    let controller: ref<MenuItemController> = buttonWidget.GetController() as MenuItemController;
    if IsDefined(controller) {
        controller.Init(data);
    }
    this.m_operationUiBtn = buttonWidget;
    return true;
}

@wrapMethod(MenuItemController)
protected cb func OnMenuChangeRelease(e: ref<inkPointerEvent>) -> Bool {
    if this.m_menuData.identifier == Constants.OperationUiDataIdentifier() {
        if e.IsAction(n"click") {
            GameInstance
                .GetUISystem(GetGameInstance())
                .QueueEvent(new OperationUiOpenPopupEvent());
        }
        return true;
    }
    return wrappedMethod(e);
}

@addMethod(MenuHubGameController)
protected cb func OnOperationUiOpenPopupEvent(evt: ref<OperationUiOpenPopupEvent>) -> Bool {
    let popup: ref<OperationUiPopup> = new OperationUiPopup();
    popup.Open(this);
    return true;
}

@if(ModuleExists("NightCityRemembers"))
public func ApplyButtonMargins(buttonWidget: wref<inkWidget>, offset: Float) {
    if !IsDefined(buttonWidget) {
        // Should never happen
        return;
    }

    buttonWidget.SetMargin(inkMargin(970.0, 340.0 + offset, 0.0, 0.0));
}

@if(!ModuleExists("NightCityRemembers"))
public func ApplyButtonMargins(buttonWidget: wref<inkWidget>, offset: Float) {
    if !IsDefined(buttonWidget) {
        // Should never happen
        return;
    }

    buttonWidget.SetMargin(inkMargin(970.0, 170.0 + offset, 0.0, 0.0));
}

