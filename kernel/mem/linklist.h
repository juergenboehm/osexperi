
#ifndef __libs_linklist_h
#define __libs_linklist_h


#define LINK_T(typ) typ##links_t

#define LINK_S(typ) struct typ##links_s { \
													struct typ *next; \
													struct typ **prev; \
										  }

// inserts before the element pointed to by *elem_nex_pp
// if insert before elem_nex, the element elem_nex_pp must point to
// elem_1.link.next where elem_1 is the element before the element elem_nex
// before which the insertion is intended.
// but usually (up to know) elem_nex_pp is a pointer to the root pointer of the list

#define LL_INSERT_BEFORE(elem, elem_nex_pp, links, typ) { typ *a = (elem); typ **b = (elem_nex_pp); \
                                                a->links.next = *b; \
                                                if (*b) { \
                                                   (*b)->links.prev = &(a->links.next); \
                                                } \
                                                a->links.prev = b; \
                                                *b = a; \
                                              }





#define LL_DELETE(elem_pp, links, typ) { typ **a = (elem_pp); \
																  { \
																	typ *b = *a; \
																  typ *s = b->links.next; \
																  if (s) { \
																     s->links.prev = b->links.prev; \
																  } \
																  *(b->links.prev) = s; \
																  *a = s; \
																} \
														 }




#endif /* __libs_linklist_h */
