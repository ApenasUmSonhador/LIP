/* Autor: Arthur Vinicius Carneiro Nunes */

/* (1.1) 
    Ele inicia o texto explicando como inicializar pelo cmd nosso ambiente de desenvolvimento,
    confesso ainda estar confuso sobre comoo utilizar outros editores de código para rodar o oz,
    mas, sinceramente, por enquanto, não vejo necessidade de mudar Emacs.

    Nos é introduzido a palavra reservada "Browse" que é utilizada para visualizar o valor de uma variável.
*/
{Browse 9999* 9999} /* -> 99980001 */

/* Como não sou bobo nem nada, corri para realizar o famoso "Hello World" e, para minha surpresa, obtive erros. */
{Browse "Hello World"} /* -> [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100] */

/* Aparentemente, o Browse não é capaz de imprimir strings, mas sim, seus valores ASCII.
    Mudei de aspas duplas para aspas simples e obtive o "resultado esperado": */
{Browse 'Hello World'} /* -> 'Hello World' */

/*  Aparentemente ao utilizar as aspas duplas eu transformo a "string" em uma cadeia de chars que serão lidos como ASCII...
    Apenas estou chutando isso, não vou me aprofundar no momento, há muito a ser lido.
    
    Algo interessante, a utilização de {...} é feita ao chamar funções e procedimentos
*/

/* (1.2)
    A declaração de variáveis deve ser realizada da seguinte maneira:
*/
declare /*(avisa que irá declarar algo) */
V = 9999 * 9999 /*(LETRA INICIAL MAIÚSCULA, se não há erro) */
{Browse V * V} /*-> 9996000599960001 */
/*  A variável fica armazenada em uma memoria do sistema que apelidaremos de "store"
    PS: Por já ter contato com o framework Vue.js, esse conceito já me soa familiar
        e será interessante explorá-lo
*/


/* (1.3) 
    Funções! Até  que enfim!
    Ele introduz  a palavra reservada "fun" e como utilizá-la, e o conceito de recursão, muito bacana!
    Declarei portanto minha primeira função em oz:
*/
declare
fun {Fact N} /* Iniciando sempre com maiúscula e logo em seguida seu parâmetro */
    if N == 0 then 1 else N* {Fact N-1} end
end
{Browse {Fact 10}} /* -> 3628800 */

/*  E aqui meu ambiente deu pau... não entendi o que estava fazendo de errado, afinal segui o livro
    Então reiniciei o ambiente e... foi...
    Que estressante kkk 
    
    Fiz os casos maiores e até mesmo a função de combinação:*/
declare
fun {Comb N K}
    {Fact N} div ({Fact K} * {Fact N-K})
end
{Browse {Comb 10 3}} /* -> 120 */

/* Por último, se é comentado muito por cima sobre funções abstratas... Nada de mais a acrescentar */

/* (1.4)
    Listas, achei interessante a abordagem de começar a contagem do 1, e pensei no seguinte quando me foi apresentado a "figure 1.1":
        Em Oz as listas funcionam como uma lista simplesmente encadeada, de maneira que, cada "nó" tem a informação de si e para quem liga, como a ideia de "cabeça e cauda":
            L = [ 1 2 3 4]
            L.1 -> Head: 1; Tail: [2 3 4]
            L.2 -> Head: 2; Tail: [3 4]
            L.3 -> Head: 3; Tail: [4]
            L.4 -> Head: 4; Tail: Null

        Lista vazia não é [], mas Null e suas separações não são feitas por virgula, mas por simples espaço.
*/

{Browse [5 6 7 8]} /* -> [5 6 7 8] */

/*
    Logo após, o próprio livro deixa claro que minha percepção está correta.
        "The notation [5 6 7 8] is a shortcut.A list is actually a chain of links, where each
        link contains two things: one list element and a reference to the rest of the chain.
        Lists are always created one element at a time, starting with nil and adding links"
*/
declare
    H=5
    T=[6 7 8]
{Browse H|T} /* -> [5 6 7 8] */

declare
L=[5 6 7 8]
{Browse L.1} /* -> 5 */
{Browse L.2} /* -> [6 7 8] */

declare
L=[5 6 7 8]
case L of H|T then {Browse H} {Browse T} end /* -> 5 [6 7 8] */

/*
    Aqui aprendi que o "case" é uma estrutura de controle que permite a execução de um bloco de código dependendo do valor de uma variável.
    A sintaxe é a seguinte:
        case <variável> of <valor> then <bloco de código> end
    E que o "|" é utilizado para separar a cabeça da cauda de uma lista
    Enfim temos o suficiente para fazer o triangulo de Pascal!
*/
declare Pascal AddList ShiftLeft ShiftRight
fun {Pascal N}
    if N==1 then [1]
    else
    {AddList {ShiftLeft {Pascal N-1}} {ShiftRight {Pascal N-1}}}
    end
end

fun {ShiftLeft L}
    case L of H|T then
    H|{ShiftLeft T}
    else [0] end
end
fun {ShiftRight L} 0|L end

fun {AddList L1 L2}
    case L1 of H1|T1 then
        case L2 of H2|T2 then
            H1+H2|{AddList T1 T2}
        end
        else nil end
end

{Browse{Pascal 20}} /* -> [1 19 171 969 3876 11628 27132
                            50388 75582 92378 92378
                            75582 50388 27132 11628 
                            3876 969 171 19 1]
                    */
/* Algo tão simples mas com uma sintaxe tão confusa que me levou tempo até entender o que eu mesmo estava fazendo */

/* (1.6 e 1.7)
    Otimizando!
*/
declare Pascal AddList ShiftLeft ShiftRight
fun {Pascal N}
    if N < 1 then nil
    else
    if N==1 then [1]
    else L in
    L = {Pascal N-1} /* Não fazer a mesma operação 2 vezes! */
    {AddList {ShiftLeft L} {ShiftRight L}}
    end
end

fun {ShiftLeft L}
    case L of H|T then
    H|{ShiftLeft T}
    else [0] end
end
fun {ShiftRight L} 0|L end

fun {AddList L1 L2}
    case L1 of H1|T1 then
        case L2 of H2|T2 then
            H1+H2|{AddList T1 T2}
        end
        else nil end
end

{Browse{Pascal 20}} /* -> [1 19 171 969 3876 11628 27132
                            50388 75582 92378 92378
                            75582 50388 27132 11628 
                            3876 969 171 19 1]
                    */
/* (1.9 e 1.10) 
    Nos é introduzido o conceito de Concorrencia, o que é muito bacana pois nos permite realizar tarefas simultaneamente:
*/

thread P in
    P={Pascal 30}
    {Browse P}
end
{Browse 99*99} /* Primeiro será printado 99*99 que é muito mais rapido que calcular pascal de 30, sendo as operações feitas simultaneamente */