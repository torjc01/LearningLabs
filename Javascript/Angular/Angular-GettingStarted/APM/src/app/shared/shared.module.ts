import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ConvertToSpacesPipe } from './convert-to-spaces.pipe';
import { StarComponent } from './star.component';
import { TelephonePipe } from './telephone.pipe';
import { CodePostalPipe } from './codepostal.pipe';
import { FormsModule } from '@angular/forms';

@NgModule({
  declarations: [
    ConvertToSpacesPipe, 
    StarComponent, 
    TelephonePipe, 
    CodePostalPipe, 
  ],
  imports: [
    CommonModule
  ], 
  exports: [
    CommonModule, 
    FormsModule,
    StarComponent, 
    ConvertToSpacesPipe, 
    TelephonePipe, 
    CodePostalPipe
  ]
})
export class SharedModule { }
