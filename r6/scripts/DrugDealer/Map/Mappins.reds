module DrugDealer.Map

// -----------------------------------------------------------------------------
// Mappins - Drug Dealer
// -----------------------------------------------------------------------------
@addMethod(BaseMappinBaseController)
protected final func UpdateDrugDealerIcon(opt forMinimap: Bool) {
    let texturePart: CName = n"icon";
    if forMinimap {
        texturePart = n"mappin";
    }

    let drugDealerMappinData = this.GetMappin().GetScriptData() as DrugDealerMappinData;
    if IsDefined(drugDealerMappinData) {
        inkImageRef.SetAtlasResource(this.iconWidget, drugDealerMappinData.GetResource());
        inkImageRef.SetTexturePart(this.iconWidget, texturePart);
    }
}

@wrapMethod(BaseWorldMapMappinController)
protected func UpdateIcon() {
    wrappedMethod();
    if Equals(this.GetMappin().GetVariant(), gamedataMappinVariant.GetUpVariant) {
        this.UpdateDrugDealerIcon();
    }
}

@wrapMethod(QuestMappinController)
protected func UpdateIcon() {
    wrappedMethod();
    if Equals(this.GetMappin().GetVariant(), gamedataMappinVariant.GetUpVariant) {
        this.UpdateDrugDealerIcon();
    }
}

@wrapMethod(MinimapPOIMappinController)
protected final func UpdateIcon() {
    wrappedMethod();
    if Equals(this.GetMappin().GetVariant(), gamedataMappinVariant.GetUpVariant) {
        this.UpdateDrugDealerIcon(true);
    }
}

// Override display name
@wrapMethod(WorldMapTooltipController)
public func SetData(const data: script_ref<WorldMapTooltipData>, menu: ref<WorldMapMenuGameController>) {
    wrappedMethod(data, menu);
    let ddMappin = Deref(data).mappin.GetScriptData() as DrugDealerMappinData;
    if IsDefined(ddMappin) {
        inkTextRef.SetText(this.m_titleText, ddMappin.displayName);
    }
}

