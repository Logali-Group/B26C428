using {ProductsService as s} from '../products-service';

annotate s.Suppliers with {
    @title : 'Suppliers'
    ID @Common: {
        Text : supplierName,
        TextArrangement : #TextOnly
    };
};
