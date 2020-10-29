#include "lib.h"

/** STRING **/

void hexPrint(char* a, FILE *pFile) {
    int i = 0;
    while (a[i] != 0) {
        fprintf(pFile, "%02hhx", a[i]);
        i++;
    }
    fprintf(pFile, "00");
}

/** Lista **/

void listRemove(list_t* l, void* data, funcCmp_t* fc, funcDelete_t* fd){
	listElem_t *indice = l->first;
  if (indice != NULL){
  	while (indice != l->last) {
  		if (0 == ((int32_t) fc(data, indice->data))) {
  			if (indice == l->first){
  				listRemoveFirst(l, fd);
  				indice = l->first;
  				continue;
  			}
  			if (fd != 0) {
  				fd(indice->data);
  			}
  			listElem_t *ant = indice->prev;
  			listElem_t *sig = indice->next;
  			ant->next = sig;
  			sig->prev = ant;
  			free(indice);
  			indice = sig;
        continue;
  		}
  		if (indice != l->last){
  			indice = indice->next;
  		}
  	}
  	if (fc(data, indice->data) == 0){
  	listRemoveLast(l, fd);
  	}
  }
}

void listRemoveFirst(list_t* l, funcDelete_t* fd){
	listElem_t *aBorrar = l->first;
 	if (aBorrar != NULL) {
		listElem_t *next = l->first->next;
  		if(fd != 0){
      	fd(l->first->data);    //Se libera memoria del dato mediante funcion fd.
  		}
      l->first = next;         //"El nuevo primer nodo, es el 2do nodo" (puede ser que quede apuntado NULL tambien)
  		if(l->first!=NULL){
    		l->first->prev = NULL;
  		} else {
    		l->last = NULL;
  		}
    	free(aBorrar);
  	}
}

void listRemoveLast(list_t* l, funcDelete_t* fd){
	listElem_t *aBorrar = l->last;
	if(aBorrar != NULL){
	    listElem_t *ant = l->last->prev;
	  	if(fd != 0){
	    	fd(l->last->data);      //Se libera memoria del dato mediante funcion fd.
	  	}
    	l->last = ant;          //"El nuevo ultimo nodo, es el anteultimo nodo" (puede ser que quede apuntado NULL tambien)
    	if(l->last!=NULL){
      	l->last->next = NULL;
    	} else {
    		l->first = NULL;
    	}
    	free(aBorrar);
	}
}
