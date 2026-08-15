using {ProductsService as ps} from '../products-service';


annotate ps.Contacts with {
    fullName     @title: 'Full Name'     @Common.FieldControl: #ReadOnly;
    email        @title: 'Email'         @Common.FieldControl: #ReadOnly;
    phoneNumber  @title: 'Phone Number'  @Common.FieldControl: #ReadOnly;
};


annotate ps.Contacts with @(UI.FieldGroup: {
    $Type: 'UI.FieldGroupType',
    Data : [
        {
            $Type: 'UI.DataField',
            Value: fullName
        },
        {
            $Type: 'UI.DataField',
            Value: email
        },
        {
            $Type: 'UI.DataField',
            Value: phoneNumber
        }
    ]
});
