module DrugDealer.Map

// -----------------------------------------------------------------------------
// MapLocalizationProvider - Drug Dealer
// -----------------------------------------------------------------------------
// Credit v1ld
import Codeware.Localization.*

public class DrugDealerLocalizationProvider extends ModLocalizationProvider {
    public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
        return new DrugDealerLocalization();
    }

    public func GetFallback() -> CName {
        return n"en-us";
    }
}

public class DrugDealerLocalization extends ModLocalizationPackage {
    protected func DefineTexts() -> Void {
        // Unfortunately, GetLocalizedTextByKey doesn't work here so no localization support
        this.Text("UI-MappinTypes-DrugDealer", "Drug Dealer");
        this.Text("UI-MappinTypes-GetUp-Description", "Drug Dealer");
    }
}

