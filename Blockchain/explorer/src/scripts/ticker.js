/**
 * Title : ticker.js
 * Author: Julio Cesar Torres 
 * Date  : 2019/12/03
 * Objetivo: Recuperar o valor da cotaçao de ether a partir da API publica do infura. 
 * Permite consultar a cotação do ether em dolar, dolar canadense, libra esterlina e euro. 
 * 
 */

 // endereços das apis das cotacoes
const ethcad = "https://api.infura.io/v1/ticker/ethcad";
const ethusd = "https://api.infura.io/v1/ticker/ethusd";
const etheur = "https://api.infura.io/v1/ticker/etheur";
const ethgbp = "https://api.infura.io/v1/ticker/ethgbp";

/**
* Consulta cotacao atual do ether na moeda selecionada, e retorna 
* objeto JSON. 
* @param moeda parametro especificando as moedas envolvidas na cotacao
* @return obj JSON object com as informacoes sobre a cotacao da moeda
*/
export async function checkTicker(moeda){
    let url = ''; 

    switch(moeda){
        case 'ethcad': 
            url = ethcad; 
            break;
        case 'ethusd': 
            url = ethusd; 
            break; 
        case 'etheur': 
            url = etheur; 
            break; 
        case 'ethgbp': 
            url = ethgbp; 
            break;
        default:            // case default, usar CAD
            url = ethcad; 
    }

    let obj = await(await fetch(url)).json(); 
    // console.log("base:  ", obj.base); 
    // console.log("quote: ", obj.quote); 
    // console.log("ask    ", obj.ask);
    return obj; 
}

/**
 * Conversao de ether em moeda fiat. 
 * @param montante montante em ether a converter
 * @param moeda moeda para qual sera convertido o ether
 * @return valor do ether convertido para a moeda desejada
 */
export async function converte(montante, cotacao){
    // let cotacao = await this.checkTicker(moeda);
    // return montante * cotacao.ask; 
    return montante * cotacao;
}