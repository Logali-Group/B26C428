using {ProductsService as c} from '../products-service';

annotate c.VH_SubCategories with {
    @title : 'Sub-Categories'
    ID @Common : { 
        Text : subcategory,
        TextArrangement : #TextOnly
     };
};
