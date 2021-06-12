import { Component, OnDestroy, OnInit } from '@angular/core'; 
import { Subscription } from 'rxjs';
import { IProduct } from './product';
import { ProductService } from './product.service';


@Component({
    templateUrl: './product-list.component.html', 
    styleUrls: ['./product-list.component.css']
})
export class ProductListComponent implements OnInit, OnDestroy{
    
    
    constructor(private productService: ProductService){}


    pageTitle: string = "Product List";
    imageWidth: number = 50; 
    imageMargin: number = 2; 
    showImage: boolean = false; 
    errorMessage : string = '';
    sub!: Subscription; 
    private _listFilter: string = '';

    products: IProduct[] = [];
    filteredProducts: IProduct[] = []; 
    
    // OnInit implementation
    ngOnInit(): void {
      console.log('In OnInit()');
      this.sub = this.productService.getProducts().subscribe({
        next: products => {
          this.products = products;
          this.filteredProducts = this.products; 
        }, 
        error: err => this.errorMessage = err
      }); 
      this.listFilter = '';      
    }

    // class methods
    toggleImage(): void {
      this.showImage = !this.showImage;
    }    

    performFilter(filterBy: string): IProduct[]{
      filterBy = filterBy.toLocaleLowerCase();
      return this.products.filter((product: IProduct) => product.productName.toLocaleLowerCase().includes(filterBy));
    } 

    // getters and setters 
    get listFilter(): string {
      return this._listFilter;
    }

    set listFilter(value:string){
      this._listFilter = value;
      console.log(`In setter: ${value}`);
      this.filteredProducts = this.performFilter(value); 
    }


    ngOnDestroy(): void {
      this.sub.unsubscribe();
    }
}