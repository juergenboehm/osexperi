
#include "kerneltypes.h"
#include "libs/utils.h"

#include "fs/ext2.h"

superblock_t supblk_test_a;
bg_desc_t bg_desc_test_a;
inode_t inode_test_a;

void test_ext2()
{
	DEBUGOUT(0, "size(superblock_t) = %d\n", sizeof(supblk_test_a));
	DEBUGOUT(0, "size(bg_desc_t) = %d\n", sizeof(bg_desc_test_a));
	DEBUGOUT(0, "size(inode_t) = %d\n", sizeof(inode_test_a));
}
