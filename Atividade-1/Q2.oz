/* Autor: Arthur Vinicius Carneiro Nunes */
/*1. (a)*/
declare Exp
fun {Exp X Y}
    if Y == 1 then X
    elseif Y == 2 then X * X
    else 
        local I in 
            I = {Exp X (Y div 2)}
            if Y mod 2 == 0 then I * I
            else X * I * I
            end
        end
    end
end

{Browse {Exp 2 100}}
/* Dessa maneira não faço os 100 expoentes, mas faço: 
    100 = 50 * 50 
    50 = 25 * 25 
    25 = 12 * 12 * 1
    12 = 6 * 6
    6 = 3 * 3
    3 = 2 * 1
*/

/*1. (b)*/
declare Fact
fun {Fact N}
    if N == 0 then 1
    else N * {Fact N-1}
    end
end

{Browse {Fact 100}}
/* Creio que não é possível otimizar mais que isso, uma vez que realmente precisamos fazer n operações para encontrar o fatorial */

/*2. (a)*/
declare Comb MultUntil
fun {Comb N K}
    {MultUntil N (N-K+1)} div {MultUntil K 1}
end

fun {MultUntil N K}
    if N < K then 1
    else N * {MultUntil N-1 K}
    end
end

/*2. (b)*/
declare EficcientComb Comb MultUntil
fun {EficcientComb N K}
    if K > (N div 2) then {Comb N (N-K)}
    else {Comb N K}
    end
end
fun {Comb N K}
    {MultUntil N (N-K+1)} div {MultUntil K 1}
end

fun {MultUntil N K}
    if N < K then 1
    else N * {MultUntil N-1 K}
    end
end

/* 3. */
declare Pascal AddList ShiftLeft ShiftRight
fun {Pascal N}
    if N < 1 then nil
    else
    if N==1 then [1]
    else L in
    L = {Pascal N-1}
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
/* A correção parcial da função Pascal pode ser demonstrada mostrando que, se a função termina, ela produz a saída correta. Vamos analisar a função Pascal:

POR INDUÇÃO, MOSTRAR QUE SE: {Pascal N-1}, CORRETO, ENTÃO {Pascal N}, CORRETO.

- Casos Base: 
    Quando N < 1, a função retorna nil. Isso está correto, pois não há linha 0 ou negativa no triângulo de Pascal.
    Quando N == 1, a função retorna [1]. Isso está correto, pois a primeira linha do triângulo de Pascal é [1].
    Portanto, para N <= 1, a função Pascal está correta.
- Caso Recursivo: Para N > 1, a função calcula L = {Pascal N-1}. Isso significa que L é a linha N-1 do triângulo de Pascal. Em seguida, a função chama {AddList {ShiftLeft L} {ShiftRight L}}. Isso significa que a função calcula a linha N do triângulo de Pascal a partir da linha N-1. Portanto, a função Pascal está correta, uma vez que para N > 1 sempre retornará ao caso N = 1.
*/

/* 4. Ele claramente não aprova, pois é claro que após um certo tamanho de input ele irá demorar várias vezes mais que um algoritmo de ordem polinomial inferior, por óbvio eles não são práticos, sendo assim, devemos buscar uma solução melhor sempre que possível. */

/*5  PÉSSIMA IDEIA, pois a lista será infinita dando a nós um loop infinito que não pode ser calculado*/

/*6.*/
/*(a)*/
declare Add Subtract Multiply Mull
fun {Add X Y}
   X+Y
end
fun {Subtract X Y}
   X-Y
end
fun {Multiply X Y}
   X*Y
end
fun {Mull X Y}
   (X+1)*(Y+1)
end

declare GenericPascalList
fun {GenericPascalList Op N}
   if N==1 then [1]
   else {GenericPascal Op N}|{GenericPascalList Op N-1} end
end

{Browse {GenericPascalList Add 7}}
{Browse {GenericPascalList Subtract 7}} % Alterna entre números positivos e negativos
{Browse {GenericPascalList Multiply 7}} 
/* Todos os elementos a partir da segunda linha são 0 uma vez que 0 * qualquer coisa é 0, e ele aparece a partir do primeiro shift */
{Browse {GenericPascalList Mull 7}} % O crescimento é maior quanto mais próximo do centro

{Browse {GenericPascal Mull 10}}

/* (b) */
for I in
   1..10 do {Browse {GenericPascal Add I}}
end
% Me lembra bastante o for do Python, mas com uma sintaxe mais simples

/* 7.
Primeiro fragmento (Variável): Browse exibe 23.
Segundo fragmento (Célula): Browse exibe 44.
Me lembrando o conceito de ponteiro, a variável é uma referência para o valor, enquanto a célula é uma referência para a referência do valor, ou seja, a célula é um ponteiro para um ponteiro.
Por isso a informação é diferente, uma vez que a célula é uma referência para a referência do valor, enquanto a variável é uma referência para o valor.
 */

/* 8. Erro bobo, a cada nova chamada da função ele está criando uma nova célula cujo valor inicial é 0, sendo assim, basta declarar fora e não atualizar o valor para 0 novamente:*/
declare
Acc = {NewCell 0} % Célula persistente para armazenar o acumulador

fun {Accumulate N}
   Acc := @Acc + N % Atualiza o valor da célula somando N
   @Acc % Retorna o valor atualizado do acumulador
end

{Browse {Accumulate 5}}    % Mostra 5
{Browse {Accumulate 100}}  % Mostra 105
{Browse {Accumulate 45}}   % Mostra 150

/* 9. */
% Carregar arquivo.
% A memória é armazenada conforme usada nos exercícios
declare
fun {NewStore}
   D={NewDictionary}
   C={NewCell 0}
   proc {Put K X}
      if {Not {Dictionary.member D K}} then
         C := @C + 1
      end
      D.K := X
   end
   fun {Get K} D.K end
   fun {Size} @C end
in
   storeobject(put:Put get:Get size:Size)
end
proc {Put S K X} {S.put K X} end
fun {Get S K} {S.get K} end
fun {Size S} {S.size} end

% (a)
% O armazenamento é criado a partir de uma classe chamada NewDictionary. É um conjunto de células de memória.

declare
S = {NewStore}
{Put S 3 [5 2 55]}
{Browse {Get S 3}}

% (b)
declare
local S = {NewStore} in
   {Put S 1 [1]}
   fun {FasterPascal N}
      if N > {Size S} then L in
     L = {FasterPascal N-1}
     {Put S N {AddList {ShiftLeft L} {ShiftRight L}}}
     {Get S N}
      else {Get S N} end
   end
end

{Browse {FasterPascal 3501}}

% (c)(d)
% Interpretação: mostrar a implementação interna do armazenamento.
declare
fun {NewMemory}
   M = {NewCell nil}
   C = {NewCell 0}
   fun {Find K}
      fun {Iter Ls}
     case Ls
     of nil then nil 
     [] L|Lr then if L.1 == K then L.2
              else {Iter Lr} end
     end
      end
   in
      {Iter @M}
   end
   fun {IsExist K}
      {Not ({Find K} == nil)}
   end
   fun {Get K}
      @{Find K}
   end
   proc {Store K V}
      if {Not {IsExist K}} then
     {Alloc K}
     C := @C + 1
      end
      {Find K} := V
   end
   proc {Alloc K}
      fun {Iter Ls K}
     case Ls
     of nil then (K|{NewCell 0})|nil
     [] L|Lr then Key = L.1 in
        if Key < K then L|{Iter Lr K}
        else (K|{NewCell 0})|Ls end
     end
      end
   in
      M := {Iter @M K}
   end
   fun {Size}
      @C
   end
in
   message(is_exist:IsExist get:Get store:Store size:Size)
end

declare
M = {NewMemory}

{M.is_exist 1} % -> false
{M.store 1 leski13} 
{M.is_exist 1} % -> true
{M.get 1} % -> leski13
{M.store 1 kuro} 
{M.get 1} % -> kuro
{M.store 2 avexandre} 
{M.get 2} % -> avexandre
{M.size} % -> 2 

/* 10. */
declare
C={NewCell 0}
thread I in
I=@C
C:=I+1
end
thread J in
J=@C
C:=J+1
end

/* (a). Sim, o motivo é que por puro destino (sorte ou azar) ambas J e I puxaram o valor de C quando este era igual a 0, portanto 0+1 = 1 em ambos os casos atribuindo 1!*/
/* (b). Sim, basta eu garantir que ambas as threads leaiam o valor de C = 0  e só depois alterar o valor do que foi lido*/

declare
C={NewCell 0}
thread I in
I=@C
{Delay 100}
C:=I+1
end
thread J in
J=@C
{Delay 100}
C:=J+1
end

/* (c). Não funciona pois os delays serão realizados em sequência 
e não mais em sincronia, o que quebra o fator que gera o numero 1.*/