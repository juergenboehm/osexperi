

#include "mem/paging.h"
#include "mem/memareas.h"

#include "mem/memmain.h"
#include "mem/pagedesc.h"

#include "libs32/klib.h"

uint32_t initial_free_mem_buddy;

int init_page_desc_system()
{

	int ret = 0;

	init_global_page_list();
	init_buddy_system(num_pages_total);

	DEBUGOUT1(0, "start buddy test.\n");

	get_order_stat(0, &initial_free_mem_buddy);

	// comment this out for testing of buddy system

	// WAIT((1 << 20) * 100);

	//test_buddy_system();

	goto end;

error:
	WAIT((1 << 24) * 7);
end:
	return ret;
}

uint32_t destroy_buddy_system_main()
{

	uint32_t ok = 0;

	ok = destroy_buddy_system();

	return ok;

}


uint32_t init_mem_system()
{
	uint32_t ok = 0;

	ok = init_paging_system();
	if (ok != 0)
		goto error;

	ok = init_page_desc_system();
	ok = 0;

	goto end;

	error:
	end:
	return ok;
}
