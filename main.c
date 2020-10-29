#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#include "lib.h"

/*char* randomString(uint32_t l) {
    // 32 a 126 = caracteres validos
    char* s = malloc(l+1);
    for(uint32_t i=0; i<(l+1); i++)
       s[i] = (char)(33+(rand()%(126-33)));
    s[l] = 0;
    return s;
}

char* randomHexString(uint32_t l) {
    char* s = malloc(l+1);
    for(uint32_t i=0; i<(l+1); i++) {
        do {
            s[i] = (char)(rand()%256);
        } while (s[i]==0);
    }
    s[l] = 0;
    return s;
}*/

void test_string(FILE *pfile){
  printf("\nPruebas string\n\n");
  strPrint("\n\n=== Pruebas string ===",pfile);
  //Pruebas strLen

  char *tiraOrig;
  int len = 0;
  tiraOrig = "hola";
  len = strLen(tiraOrig);
  printf("   Longitud de la tira ''%s'' = %d \n", tiraOrig, len);

  //Pruebas strCmp

  char *tiraCmp1;
  char *tiraCmp2;
  char *tiraCmp3;
  char *tiraCmp4;

  int resCmp12 = 0;
  int resCmp13 = 0;
  int resCmp11 = 0;
  int resCmp14 = 0;
  int resCmp41 = 0;

  tiraCmp1 = "hola";
  tiraCmp2 = "auto";
  tiraCmp3 = "uba";
  tiraCmp4 = "hola manolo";

  resCmp12 = strCmp(tiraCmp1,tiraCmp2);
  printf("   Comparacion ''%s'' con ''%s'' = %d \n", tiraCmp1, tiraCmp2, resCmp12);
  resCmp13 = strCmp(tiraCmp1,tiraCmp3);
  printf("   Comparacion ''%s'' con ''%s'' = %d \n", tiraCmp1, tiraCmp3, resCmp13);
  resCmp11 = strCmp(tiraCmp1,tiraCmp1);
  printf("   Comparacion ''%s'' con ''%s'' = %d \n", tiraCmp1, tiraCmp1, resCmp11);
  resCmp14 = strCmp(tiraCmp1,tiraCmp4);
  printf("   Comparacion ''%s'' con ''%s'' = %d \n", tiraCmp1, tiraCmp4, resCmp14);
  resCmp41 = strCmp(tiraCmp4,tiraCmp1);
  printf("   Comparacion ''%s'' con ''%s'' = %d \n", tiraCmp4, tiraCmp1, resCmp41);

  //Pruebas strClone

  char *tiraCopia;
  tiraCopia = strClone(tiraOrig);
  printf("   Clon de la tira ''%s'' = ''%s''\n", tiraOrig, tiraCopia);
  strPrint("\n\nClon de la tira ''hola'':\n",pfile);
  strPrint(tiraCopia,pfile);

  strDelete (tiraCopia);

  //Pruebas strConcat

  char *tiraHola;
  char *tiraHolaCopia;
  char *tiraTodoBien;
  char *tiraTodoBienCopia;
  char *tiraConcat;
  tiraHola = "Hola,";
  tiraHolaCopia = strClone(tiraHola);
  tiraTodoBien = " todo bien?";
  tiraTodoBienCopia = strClone(tiraTodoBien);
  tiraConcat = strConcat(tiraHolaCopia, tiraTodoBienCopia);
  printf("   Tira concatenada = ''%s''\n", tiraConcat);
  strPrint("\n\nConcatenamiento de tiras ''Hola,'' y '' todo bien?'':\n",pfile);
  strPrint(tiraConcat,pfile);

  strDelete (tiraConcat);
  strPrint("\n",pfile);

}





void test_lista(FILE *pfile){
  printf("\nPruebas list\n");
  strPrint("\n\n=== Pruebas list ===\n",pfile);

  list_t* lista;
  printf("\n   Se crea una lista nueva...\n");
  strPrint("\nSe crea una lista nueva...\n",pfile);
  lista = listNew();
  void *inicio = lista->first;
  void *fin = lista->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);

  listPrint(lista,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");

  void *anterior;
  void *siguiente;
  char *primerDato;
  char *ultimoDato;

  printf("\n   Se agrega 1 elemento...\n");
  //listAddLast(lista,"Tira elemento 1");
  char *Dato1;// = (char*) malloc(16*sizeof(char));
  Dato1 = strClone("Tira elemento 1");
  listAddFirst(lista,Dato1);
  inicio = lista->first;
  fin = lista->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  if (inicio != NULL){
    primerDato = lista->first->data;
    printf("      Primer elemento en la lista = %s\n",primerDato);
    anterior = lista->first->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->first->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
    ultimoDato = lista->last->data;
    printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
    anterior = lista->last->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->last->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
  }




  printf("\n   Se elimina 1 elemento:\n");
  listRemoveLast(lista, (funcDelete_t*)&strDelete);
  inicio = lista->first;
  fin = lista->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  if (inicio != NULL){
    primerDato = lista->first->data;
    printf("      Primer elemento en la lista = %s\n",primerDato);
    anterior = lista->first->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->first->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
    ultimoDato = lista->last->data;
    printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
    anterior = lista->last->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->last->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
  }




  printf("\n   Se agrega 1 elemento...\n");
  //listAddLast(lista,"Tira elemento 1");
  char *Dato1b;// = (char*) malloc(16*sizeof(char));
  Dato1b = strClone("Tira elemento 1");
  listAddFirst(lista,Dato1b);
  inicio = lista->first;
  fin = lista->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  primerDato = lista->first->data;
  ultimoDato = lista->last->data;
  primerDato = lista->first->data;
  printf("      Primer elemento en la lista = %s\n",primerDato);
  anterior = lista->first->prev;
  printf("         Puntero a anterior = %p\n",anterior);
  siguiente = lista->first->next;
  printf("         Puntero a siguiente = %p\n",siguiente);
  ultimoDato = lista->last->data;
  printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
  anterior = lista->last->prev;
  printf("         Puntero a anterior = %p\n",anterior);
  siguiente = lista->last->next;
  printf("         Puntero a siguiente = %p\n",siguiente);





  printf("\n   Se agrega 1 elemento...\n");
  //listAddFirst(lista,"Tira elemento 2");
  char *Dato2;// = (char*) malloc(16*sizeof(char));
  Dato2 = strClone("Tira elemento 2");
  listAddLast(lista,Dato2);
  inicio = lista->first;
  fin = lista->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  primerDato = lista->first->data;
  printf("      Primer elemento en la lista = %s\n",primerDato);
  anterior = lista->first->prev;
  printf("         Puntero a anterior = %p\n",anterior);
  siguiente = lista->first->next;
  printf("         Puntero a siguiente = %p\n",siguiente);
  ultimoDato = lista->last->data;
  printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
  anterior = lista->last->prev;
  printf("         Puntero a anterior = %p\n",anterior);
  siguiente = lista->last->next;
  printf("         Puntero a siguiente = %p\n",siguiente);



  printf("\n   Se elimina 1 elemento...\n");
  listRemoveLast(lista, (funcDelete_t*)&strDelete);
  inicio = lista->first;
  fin = lista->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  if (inicio != NULL){
    primerDato = lista->first->data;
    printf("      Primer elemento en la lista = %s\n",primerDato);
    anterior = lista->first->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->first->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
    ultimoDato = lista->last->data;
    printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
    anterior = lista->last->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->last->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
  }


  printf("\n   Se agrega 1 elemento...\n");
  //listAddLast(lista,"Tira elemento 2");
  char *Dato2b;// = (char*) malloc(16*sizeof(char));
  Dato2b = strClone("Tira elemento 1");
  listAddLast(lista,Dato2b);
  inicio = lista->first;
  fin = lista->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  primerDato = lista->first->data;
  ultimoDato = lista->last->data;
  printf("      Primer elemento en la lista = %s\n",primerDato);
  printf("      Ultimo elemento en la lista = %s\n",ultimoDato);

  printf("\n   Se agregan 8 elementos...\n");
  /*listAddLast(lista,"Tira elemento 3");
  listAddLast(lista,"Tira elemento 4");
  listAddLast(lista,"Tira elemento 5");
  listAddFirst(lista,"Tira elemento 6");
  listAddLast(lista,"Tira elemento 7");
  listAddLast(lista,"Tira elemento 8");
  listAddFirst(lista,"Tira elemento 9");
  listAddLast(lista,"Tira elemento 10");*/
  char *Dato3;// = (char*) malloc(16*sizeof(char));
  char *Dato4;// = (char*) malloc(16*sizeof(char));
  char *Dato5;// = (char*) malloc(16*sizeof(char));
  char *Dato6;// = (char*) malloc(16*sizeof(char));
  char *Dato7;// = (char*) malloc(16*sizeof(char));
  char *Dato8;// = (char*) malloc(16*sizeof(char));
  char *Dato9;// = (char*) malloc(16*sizeof(char));
  char *Dato10;// = (char*) malloc(17*sizeof(char));
  Dato3 = strClone("Tira elemento 3");
  Dato4 = strClone("Tira elemento 4");
  Dato5 = strClone("Tira elemento 5");
  Dato6 = strClone("Tira elemento 6");
  Dato7 = strClone("Tira elemento 7");
  Dato8 = strClone("Tira elemento 8");
  Dato9 = strClone("Tira elemento 9");
  Dato10 = strClone("Tira elemento 10");
  listAddLast(lista,Dato3);
  listAddLast(lista,Dato4);
  listAddFirst(lista,Dato5);
  listAddLast(lista,Dato6);
  listAddLast(lista,Dato7);
  listAddFirst(lista,Dato8);
  listAddFirst(lista,Dato9);
  listAddLast(lista,Dato10);
  inicio = lista->first;
  fin = lista->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  primerDato = lista->first->data;
  ultimoDato = lista->last->data;
  printf("      Primer elemento en la lista = %s\n",primerDato);
  printf("      Ultimo elemento en la lista = %s\n",ultimoDato);

  //imprimir la lista y luego eliminar elementos

  printf("\n   Se eliminan 2 elementos...\n");
  listRemoveLast(lista, (funcDelete_t*)&strDelete);
  listRemoveLast(lista, (funcDelete_t*)&strDelete);
  inicio = lista->first;
  fin = lista->last;
  printf("      Puntero a primer elemstrClone(ento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  if (inicio != NULL){
    primerDato = lista->first->data;
    ultimoDato = lista->last->data;
    printf("      Primer elemento en la lista = %s\n",primerDato);
    printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
  }

  printf("\n   Se eliminan 7 elementos...\n");
  listRemoveLast(lista, (funcDelete_t*)&strDelete);
  listRemoveFirst(lista, (funcDelete_t*)&strDelete);
  listRemoveLast(lista, (funcDelete_t*)&strDelete);
  listRemoveLast(lista, (funcDelete_t*)&strDelete);
  listRemoveFirst(lista, (funcDelete_t*)&strDelete);
  listRemoveLast(lista, (funcDelete_t*)&strDelete);
  listRemoveLast(lista, (funcDelete_t*)&strDelete);
  printf("   La lista tiene que quedar con un solo elemento.\n");
  inicio = lista->first;
  fin = lista->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  if (inicio != NULL){
    primerDato = lista->first->data;
    printf("      Primer elemento en la lista = %s\n",primerDato);
    anterior = lista->first->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->first->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
    ultimoDato = lista->last->data;
    printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
    anterior = lista->last->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->last->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
  }


  printf("\n   Se elimina 1 elemento...\n");
  listRemoveLast(lista, (funcDelete_t*)&strDelete);
  printf("   La lista tiene que quedar vac'ia.\n");
  inicio = lista->first;
  fin = lista->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);



  //Pruebas listAdd

  char *input[10] = {"elemento 04","elemento 07","elemento 05","elemento 01","elemento 03","elemento 09","elemento 02","elemento 08","elemento 06","elemento 10"};
  printf("\n   Se agregan 10 elementos con listAdd...\n");

  for (int i=0;i<10;i++){
    printf("\n      Se agrega '%s' con listAdd...\n",input[i]);
    listAdd(lista,strClone(input[i]),(funcCmp_t*)&strCmp);
  }


  printf("\n   Se elimina 1 elemento al final...\n");
  listRemoveLast(lista, (funcDelete_t*)&strDelete);
  inicio = lista->first;
  fin = lista->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  if (inicio != NULL){
    primerDato = lista->first->data;
    printf("      Primer elemento en la lista = %s\n",primerDato);
    anterior = lista->first->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->first->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
    ultimoDato = lista->last->data;
    printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
    anterior = lista->last->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->last->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
  }

  printf("\n   Se elimina 1 elemento al principio...\n");
  listRemoveFirst(lista, (funcDelete_t*)&strDelete);
  inicio = lista->first;
  fin = lista->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  if (inicio != NULL){
    primerDato = lista->first->data;
    printf("      Primer elemento en la lista = %s\n",primerDato);
    anterior = lista->first->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->first->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
    ultimoDato = lista->last->data;
    printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
    anterior = lista->last->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->last->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
  }


  printf("\n   Se elimina la lista con listDelete...\n");
  listDelete(lista,(funcDelete_t*)&strDelete);


  printf("\n   Se crea lista con listNew...\n");
  lista = listNew();



  printf("\n   Se agregan 10 elementos con listAdd...\n");
  strPrint("\nSe agregan 10 elementos con listAdd...\n",pfile);

  for (int i=0;i<10;i++){
    printf("      Se agrega el %s\n",input[i]);
    listAdd(lista,strClone(input[i]),(funcCmp_t*)&strCmp);
  }
  listPrint(lista,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");


  inicio = lista->first;
  fin = lista->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  if (inicio != NULL){
    primerDato = lista->first->data;
    printf("      Primer elemento en la lista = %s\n",primerDato);
    anterior = lista->first->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->first->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
    ultimoDato = lista->last->data;
    printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
    anterior = lista->last->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = lista->last->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
  }


  printf("\n   Se clona la lista con listClone\n");

  list_t* listaClonada = listClone(lista,(funcDup_t*)&strClone);
  void *clonInicio = listaClonada->first;
  void *clonFin = listaClonada->last;

  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", clonInicio, clonFin);
  if (clonInicio != NULL){
    primerDato = listaClonada->first->data;
    printf("      Primer elemento en la lista = %s\n",primerDato);
    anterior = listaClonada->first->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = listaClonada->first->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
    ultimoDato = listaClonada->last->data;
    printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
    anterior = listaClonada->last->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = listaClonada->last->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
  }


  printf("\n   Se elimina el clon (de lista) con listDelete...\n");
  listDelete(listaClonada,(funcDelete_t*)&strDelete);
  listaClonada = NULL;

  printf("\n   Se elimina la lista con listDelete...\n");
  strPrint("\nSe elimina la lista con listDelete...\n",pfile);
  listDelete(lista,(funcDelete_t*)&strDelete);







  //Pruebas listRemove

  lista = listNew();
  printf("\n   Se agregan 5 elementos con listAdd...\n");

  for (int i=0;i<5;i++){
    printf("      Se agrega el %s\n",input[i]);
    listAdd(lista,strClone(input[i]),(funcCmp_t*)&strCmp);
  }

  inicio = lista->first;
  fin = lista->last;
  printf("\n      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  if (inicio != NULL){
    primerDato = lista->first->data;
    printf("      Primer elemento en la lista = %s\n",primerDato);
    ultimoDato = lista->last->data;
    printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
  }


  printf("\n   ... para probar que listRemove los borre...\n");
  printf("      Se elimina elemento 3 con listRemove\n");
  listRemove(lista, input[3], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
  printf("      Se elimina elemento 1 con listRemove\n");
  listRemove(lista, input[1], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
  printf("      Se elimina elemento 2 con listRemove\n");
  listRemove(lista, input[2], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
  printf("      Se elimina elemento 0 con listRemove\n");
  listRemove(lista, input[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
  printf("      Se elimina elemento 4 con listRemove\n");
  listRemove(lista, input[4], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);



  inicio = lista->first;
  fin = lista->last;
  printf("\n      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", inicio, fin);
  if (inicio != NULL){
    primerDato = lista->first->data;
    printf("      Primer elemento en la lista = %s\n",primerDato);
    ultimoDato = lista->last->data;
    printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
  }

  printf("\n      Se intenta remover elemento con listRemove de lista vac'ia...\n");
  listRemove(lista, input[4], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);

  printf("\n   Se elimina la lista con listDelete...\n");
  listDelete(lista,(funcDelete_t*)&strDelete);

  lista = listNew();
  printf("\n   Test orden palabras listAdd\n");

  listAdd(lista,strClone("7500"),(funcCmp_t*)&strCmp);
  listAdd(lista,strClone("75f6c5d0783800"),(funcCmp_t*)&strCmp);



  listDelete(lista,(funcDelete_t*)&strDelete);

  lista = listNew();
  printf("\n   Agrego varias veces los mismos elemento\n");

  for (int i=0;i<7;i++){
    listAdd(lista,strClone("01"),(funcCmp_t*)&strCmp);
    listAdd(lista,strClone("02"),(funcCmp_t*)&strCmp);
    listAdd(lista,strClone("03"),(funcCmp_t*)&strCmp);
  }


  listRemove(lista, "02", (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);

  listDelete(lista,(funcDelete_t*)&strDelete);
}



void test_sorter(FILE *pfile){
  printf("\nPruebas sorter\n");
  strPrint("\n\n=== Pruebas sorter ===\n",pfile);

  printf("\n   Pruebas fs_sizeModFive,\n");
  char *tira = "Hola";
  printf("      Resto de longitud de tira '%s' dividido 5 = %d\n", tira, fs_sizeModFive(tira));
  tira = "Holas";
  printf("      Resto de longitud de tira '%s' dividido 5 = %d\n", tira, fs_sizeModFive(tira));
  tira = "Hola, soy una tira...";
  printf("      Resto de longitud de tira '%s' dividido 5 = %d\n", tira, fs_sizeModFive(tira));
  tira = "Chau, me fui.";
  printf("      Resto de longitud de tira '%s' dividido 5 = %d\n", tira, fs_sizeModFive(tira));


  printf("\n   Pruebas fs_firstChar,\n");
  char *test1 = "A";
  printf("      Tira de entrada = '%s', valor hexa del primer char = %02hhx\n", test1, fs_firstChar(test1));
  char *test2 = "";
  printf("      Tira de entrada = '%s', valor hexa del primer char = %02hhx\n", test2, fs_firstChar(test2));


  printf("\n   Pruebas fs_bitSplit,\n");
  char *test7 = "";
  printf("      Tira de entrada = '%s', resultado de fs_bitSplit en hexa = %02hhx\n", test7, fs_bitSplit(test7));
  char *test3 = " ";
  printf("      Tira de entrada = '%s', resultado de fs_bitSplit en hexa = %02hhx\n", test3, fs_bitSplit(test3));
  char *test4 = "@";
  printf("      Tira de entrada = '%s', resultado de fs_bitSplit en hexa = %02hhx\n", test4, fs_bitSplit(test4));
  char *test5 = "sarasa";
  printf("      Tira de entrada = '%s', resultado de fs_bitSplit en hexa = %02hhx\n", test5, fs_bitSplit(test5));
  char *test6 = "sarasa";
  printf("      Tira de entrada = '%s', resultado de fs_bitSplit en hexa = %02hhx\n", test6, fs_bitSplit(test6));


  printf("\n   Se crea un sorter nuevo con 5 slots,\n");
  printf("      usando fs_sizeModFive...\n");
  strPrint("\nSe crea un sorter nuevo con 5 slots usando fs_sizeModFive...\n",pfile);

  sorter_t* sorter;
  uint16_t slots;
  slots = 5;
  sorter = sorterNew(slots, (funcSorter_t*)&fs_sizeModFive, (funcCmp_t*)&strCmp);


  printf("\n   Se agregan 6 elementos al sorter...\n");
  strPrint("\nSe agregan 6 elementos al sorter...\n\n",pfile);


  printf("      Se agrega ''robot''...\n");
  sorterAdd(sorter,strClone("robot"));
  printf("      Se agrega ''casa''...\n");
  sorterAdd(sorter,strClone("casa"));
  printf("      Se agrega ''auto''...\n");
  sorterAdd(sorter,strClone("auto"));
  printf("      Se agrega ''uba''...\n");
  sorterAdd(sorter,strClone("uba"));
  printf("      Se agrega ''ubuntu''...\n");
  sorterAdd(sorter,strClone("ubuntu"));
  printf("      Se agrega ''yo''...\n");
  sorterAdd(sorter,strClone("yo"));

    sorterPrint(sorter, pfile, (funcPrint_t*)&strPrint);

  printf("\n   Se concatenan los elementos de cada slot con sorterGetConcatSlot...\n");
  char *concSlot;
  concSlot = sorterGetConcatSlot(sorter, 0);
  printf("      Resultado slot 0 = %s\n",concSlot);
  strDelete(concSlot);
  concSlot = sorterGetConcatSlot(sorter, 1);
  printf("      Resultado slot 1 = %s\n",concSlot);
  strDelete(concSlot);
  concSlot = sorterGetConcatSlot(sorter, 2);
  printf("      Resultado slot 2 = %s\n",concSlot);
  strDelete(concSlot);
  concSlot = sorterGetConcatSlot(sorter, 3);
  printf("      Resultado slot 3 = %s\n",concSlot);
  strDelete(concSlot);
  concSlot = sorterGetConcatSlot(sorter, 4);
  printf("      Resultado slot 4 = %s\n",concSlot);
  strDelete(concSlot);






  printf("\n   Se remueve 1 elemento (''yo'') del sorter...\n");
  sorterRemove(sorter,"yo",(funcDelete_t*)&strDelete);
  printf("\n   Se remueve 1 elemento (''robot'') del sorter...\n");
  sorterRemove(sorter,"robot",(funcDelete_t*)&strDelete);
  printf("\n   Se remueve 1 elemento (''vivo'') del sorter...\n");
  sorterRemove(sorter,"vivo",(funcDelete_t*)&strDelete);

  printf("\n   Se concatenan los elementos de cada slot con sorterGetConcatSlot...\n");
  concSlot = sorterGetConcatSlot(sorter, 0);
  printf("      Resultado slot 0 = %s\n",concSlot);
  strDelete(concSlot);
  concSlot = sorterGetConcatSlot(sorter, 1);
  printf("      Resultado slot 1 = %s\n",concSlot);
  strDelete(concSlot);
  concSlot = sorterGetConcatSlot(sorter, 2);
  printf("      Resultado slot 2 = %s\n",concSlot);
  strDelete(concSlot);
  concSlot = sorterGetConcatSlot(sorter, 3);
  printf("      Resultado slot 3 = %s\n",concSlot);
  strDelete(concSlot);
  concSlot = sorterGetConcatSlot(sorter, 4);
  printf("      Resultado slot 4 = %s\n",concSlot);
  strDelete(concSlot);


  printf("\n   Se limpia el slot 1 con sorterCleanSlot...\n");
  sorterCleanSlot(sorter, 1,(funcDelete_t*)&strDelete);  //esto deja la lista vacia...

  printf("\n   Se concatenan los elementos de cada slot con sorterGetConcatSlot...\n");
  concSlot = sorterGetConcatSlot(sorter, 0);
  printf("      Resultado slot 0 = %s\n",concSlot);
  strDelete(concSlot);
  concSlot = sorterGetConcatSlot(sorter, 1);
  printf("      Resultado slot 1 = %s\n",concSlot);
  strDelete(concSlot);
  concSlot = sorterGetConcatSlot(sorter, 2);
  printf("      Resultado slot 2 = %s\n",concSlot);
  strDelete(concSlot);
  concSlot = sorterGetConcatSlot(sorter, 3);
  printf("      Resultado slot 3 = %s\n",concSlot);
  strDelete(concSlot);
  concSlot = sorterGetConcatSlot(sorter, 4);
  printf("      Resultado slot 4 = %s\n",concSlot);
  strDelete(concSlot);

  printf("\n   Se clona la lista del slot 4 con sorterGetSlot...\n");
  list_t* listaClonada = sorterGetSlot(sorter, 4,(funcDup_t*)&strClone);
  void *clonInicio = listaClonada->first;
  void *clonFin = listaClonada->last;
  printf("      Puntero a primer elemento = %p\n      Puntero a ultimo elemento = %p\n", clonInicio, clonFin);
  if (clonInicio != NULL){
    char *primerDato = listaClonada->first->data;
    printf("      Primer elemento en la lista = %s\n",primerDato);
    void *anterior = listaClonada->first->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    void *siguiente = listaClonada->first->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
    char *ultimoDato = listaClonada->last->data;
    printf("      Ultimo elemento en la lista = %s\n",ultimoDato);
    anterior = listaClonada->last->prev;
    printf("         Puntero a anterior = %p\n",anterior);
    siguiente = listaClonada->last->next;
    printf("         Puntero a siguiente = %p\n",siguiente);
  }

  printf("\n   Se borra la lista clonada a partir del slot 1 con listDelete...\n");
  listDelete(listaClonada,(funcDelete_t*)&strDelete);

  printf("\n   Se elimina el sorter...\n");
  sorterDelete(sorter,(funcDelete_t*)&strDelete);



  printf("\n   Se crea un sorter nuevo con 256 slots,\n");
  printf("      usando fs_firstChar...\n");
  slots = 256;
  sorter = sorterNew(slots, (funcSorter_t*)&fs_firstChar, (funcCmp_t*)&strCmp);

  printf("\n   Se elimina el sorter...\n");
  sorterDelete(sorter,(funcDelete_t*)&strDelete);

}

int main (void){
    FILE *pfile = fopen("salida.caso.propios.txt","w");
    printf("\nFunciones de 'lib.asm' y 'lib.c' se prueban con\n");
    printf("impresiones en archivo de texto y en consola (pantalla).\n");
    strPrint("\nFunciones de 'lib.asm' y 'lib.c' se prueban con\n",pfile);
    strPrint("impresiones en archivo de texto y en consola (pantalla).\n",pfile);
    test_string(pfile);
    test_lista(pfile);
    test_sorter(pfile);
    printf("\n");
    fclose(pfile);
    return 0;
}
