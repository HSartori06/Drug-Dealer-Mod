module DrugDealer.Translation

import DrugDealer.Lab.DrugCategory
import DrugDealer.State.{TurfLocation, TurfControl}
import DrugDealer.Operation.{OperationType, OperationStatus}
import DrugDealer.Organization.Organization

// -----------------------------------------------------------------------------
// Translation - DrugDealer
// -----------------------------------------------------------------------------
public func TranslateDrugCategory(drugCategory: DrugCategory) -> String {
    switch drugCategory {
        case DrugCategory.Deliriants:
            return GetLocalizedTextByKey(n"DD.DrugCategory.Deliriants");
        case DrugCategory.Depressants:
            return GetLocalizedTextByKey(n"DD.DrugCategory.Depressants");
        case DrugCategory.Dissociatives:
            return GetLocalizedTextByKey(n"DD.DrugCategory.Dissociatives");
        case DrugCategory.Empathogens:
            return GetLocalizedTextByKey(n"DD.DrugCategory.Empathogens");
        case DrugCategory.Psychedelics:
            return GetLocalizedTextByKey(n"DD.DrugCategory.Psychedelics");
        case DrugCategory.Stimulants:
            return GetLocalizedTextByKey(n"DD.DrugCategory.Stimulants");
        default:
            return "";
    }
}

public func TranslateTurfLocation(turfLocation: TurfLocation) -> String {
    switch turfLocation {
        case TurfLocation.Watson:
            return GetLocalizedTextByKey(n"DD.Turf.Watson");
            break;
        case TurfLocation.SantoDomingo:
            return GetLocalizedTextByKey(n"DD.Turf.SantoDomingo");
            break;
        case TurfLocation.Badlands:
            return GetLocalizedTextByKey(n"DD.Turf.Badlands");
            break;
        case TurfLocation.Westbrook:
            return GetLocalizedTextByKey(n"DD.Turf.Westbrook");
            break;
        case TurfLocation.Heywood:
            return GetLocalizedTextByKey(n"DD.Turf.Heywood");
            break;
        case TurfLocation.Pacifica:
            return GetLocalizedTextByKey(n"DD.Turf.Pacifica");
            break;
        default:
            return "";
    }
}

public func TranslateTurfControl(turfControl: TurfControl) -> String {
    switch turfControl {
        case TurfControl.Controlled:
            return GetLocalizedTextByKey(n"DD.Turf.Controlled");
            break;
        case TurfControl.Constested:
            return GetLocalizedTextByKey(n"DD.Turf.Constested");
            break;
        case TurfControl.Surrendered:
            return GetLocalizedTextByKey(n"DD.Turf.Surrendered");
            break;
        default:
            return "";
    }
}

public func TranslateOperationType(operationType: OperationType) -> String {
    switch operationType {
        case OperationType.Pushers:
            return GetLocalizedTextByKey(n"DD.Operation.Pushers");
            break;
        case OperationType.Brothel:
            return GetLocalizedTextByKey(n"DD.Operation.Brothel");
            break;
        default:
            return "";
    }
}

public func TranslateOperationStatus(operationStatus: OperationStatus) -> String {
    switch operationStatus {
        case OperationStatus.Inactive:
            return GetLocalizedTextByKey(n"DD.Operation.Inactive");
            break;
        case OperationStatus.Active:
            return GetLocalizedTextByKey(n"DD.Operation.Active");
            break;
        default:
            return "";
    }
}

public func TranslateOrganization(organization: Organization) -> String {
    switch organization {
        case Organization.Maelstrom:
            return GetLocalizedTextByKey(n"DD.Organization.Maelstrom");
            break;
        case Organization.TygerClaws:
            return GetLocalizedTextByKey(n"DD.Organization.TygerClaws");
            break;
        case Organization.Valentinos:
            return GetLocalizedTextByKey(n"DD.Organization.Valentinos");
            break;
        case Organization.SixthStreet:
            return GetLocalizedTextByKey(n"DD.Organization.SixthStreet");
            break;
        case Organization.VoodooBoys:
            return GetLocalizedTextByKey(n"DD.Organization.VoodooBoys");
            break;
        case Organization.Animals:
            return GetLocalizedTextByKey(n"DD.Organization.Animals");
            break;
        case Organization.Scavengers:
            return GetLocalizedTextByKey(n"DD.Organization.Scavengers");
            break;
        case Organization.Wraiths:
            return GetLocalizedTextByKey(n"DD.Organization.Wraiths");
            break;
        case Organization.Moxes:
            return GetLocalizedTextByKey(n"DD.Organization.Moxes");
            break;
        case Organization.Aldecaldos:
            return GetLocalizedTextByKey(n"DD.Organization.Aldecaldos");
            break;
        case Organization.BarghestMilitia:
            return GetLocalizedTextByKey(n"DD.Organization.BarghestMilitia");
            break;
        case Organization.Ncpd:
            return GetLocalizedTextByKey(n"DD.Organization.Ncpd");
            break;
        case Organization.Prostitutes:
            return GetLocalizedTextByKey(n"DD.Organization.Prostitutes");
            break;
        default:
            return "";
    }
}

