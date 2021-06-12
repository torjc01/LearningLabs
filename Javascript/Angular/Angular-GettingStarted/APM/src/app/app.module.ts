import { BrowserModule }        from '@angular/platform-browser';
import { NgModule }             from '@angular/core';
import { HttpClientModule }     from '@angular/common/http';

import { AppComponent }         from './app.component';
import { ProductListComponent } from './products/product-list.component';
import { FormsModule }          from '@angular/forms';
import { ConvertToSpacesPipe }  from './shared/convert-to-spaces.pipe';
import { StarComponent }        from './shared/star.component';
import { TelephonePipe }        from './shared/telephone.pipe';
import { CodePostalPipe }       from './shared/codepostal.pipe';
import { ProductDetailComponent } from './products/product-detail.component';
import { WelcomeComponent } from './home/welcome.component';
import { RouterModule } from '@angular/router';
import { ProductDetailGuard } from './products/product-detail.guard';

@NgModule({
  declarations: [
    AppComponent, ProductListComponent, 
    ConvertToSpacesPipe, StarComponent, 
    TelephonePipe, CodePostalPipe, 
    ProductDetailComponent, WelcomeComponent
  ],
  imports: [
    BrowserModule, FormsModule, 
    HttpClientModule, 
    RouterModule.forRoot([
      { path: 'products', component: ProductListComponent}, 
      { 
        path: 'products/:id', 
        canActivate: [ProductDetailGuard],
        component: ProductDetailComponent
      }, 
      { path: 'welcome', component: WelcomeComponent}, 
      { path: '', redirectTo:'welcome', pathMatch: 'full'}, 
      { path: '**', redirectTo: 'welcome', pathMatch: 'full'} 

    ])
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
