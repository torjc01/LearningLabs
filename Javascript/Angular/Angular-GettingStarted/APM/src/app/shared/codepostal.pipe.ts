import { Pipe, PipeTransform } from "@angular/core";

@Pipe({
    name: 'codepostal'
})
export class CodePostalPipe implements PipeTransform{
   
    transform(value: string) {

        // Clean-up input 
        let codepostal = value.replace(' ', ''); 
        codepostal = codepostal.replace('-', ''); 

        // Verify legal length
        if(codepostal.length != 6){
            console.log("Code postal est invalide."); 
            return ""; 
        }

        // TODO: Valider les positions numeriques et alpha du code postal

        codepostal = codepostal.toUpperCase();
        // Return code postal dans le gabatit X9X 9X9
        return `${codepostal.substr(0,3)} ${codepostal.substr(3,3)}`;
    }

}