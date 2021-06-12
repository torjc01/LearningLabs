import { Pipe, PipeTransform } from "@angular/core";
@Pipe({
    name: 'telephone'
})
export class TelephonePipe implements PipeTransform{

    transform(value: string) {

        // Clean-up du numero de telephone reçu 
        // Supprime parentheses 
        let tel =  value.replace('(', '')
        console.log(tel);
        tel = tel.replace(')', '')
        console.log(tel);
        
        // Supprime tiret
        let pieces = tel.split('-'); 
        tel = pieces.join('');

        // Supprime espaces 
        pieces = tel.split(' '); 
        tel = pieces.join('');

        // Formatation du telephone dans le gabarit (999) 999-9999
        return `(${tel.substr(0,3)}) ${tel.substr(3,3)}-${tel.substr(6,4)}`;
    }
}