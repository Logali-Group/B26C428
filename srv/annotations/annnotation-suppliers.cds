using {ProductsService as s} from '../products-service';
using from './annotations-contacts';

annotate s.Suppliers with {
    @title: 'Suppliers'
    ID            @Common: {
        Text           : supplierName,
        TextArrangement: #TextOnly
    };

    supplier      @title : 'Supplier'       @Common.FieldControl: #ReadOnly;
    supplierName  @title : 'Supplier Name'  @Common.FieldControl: #ReadOnly;
    webAddress    @title : 'Web Address'    @Common.FieldControl: #ReadOnly;
};

annotate s.Suppliers with @(UI.FieldGroup: {
    $Type: 'UI.FieldGroupType',
    Data : [
        {
            $Type: 'UI.DataField',
            Value: supplier
        },
        {
            $Type: 'UI.DataField',
            Value: supplierName
        },
        {
            $Type: 'UI.DataField',
            Value: webAddress
        }
    ]
});
