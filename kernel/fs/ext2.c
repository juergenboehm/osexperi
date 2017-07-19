
#include "kerneltypes.h"
#include "libs/utils.h"
#include "libs32/klib.h"

#include "fs/vfs.h"
#include "fs/ext2.h"


superblock_ext2_t* gsb_ext2;
bg_desc_ext2_t* gbgd_ext2;

uint32_t g_blocks_per_group_ext2;

uint32_t g_ext2_blocksize;

inode_ext2_t* g_root_inode_ext2;


#if 0
superblock_ext2_t supblk_test_a;
bg_desc_ext2_t bg_desc_test_a;
inode_ext2_t inode_test_a;



#define PRINT_uint32_t(field) { uint32_t n = sprintf( p, "%25s = %12d\n", #field, ACC->field ); \
																		p += n; }

#define PRINT_uint16_t(field) { uint32_t n = sprintf( p, "%25s = %12d\n", #field, ACC->field ); \
																		p += n; }

#define PRINT_uint8_t(field) { uint32_t n = sprintf( p, "%25s = %12d\n", #field, ACC->field ); \
																		p += n; }

#define ACC sb

int sprint_superblock(superblock_ext2_t *sb, char* buf)
{
	char* p = buf;

	PRINT_uint32_t( s_inodes_count);
	PRINT_uint32_t( s_blocks_count);
	PRINT_uint32_t( s_r_blocks_count);
	PRINT_uint32_t( s_free_blocks_count);
	PRINT_uint32_t( s_free_inodes_count);
	PRINT_uint32_t( s_first_data_block);
	PRINT_uint32_t( s_log_block_size);
	PRINT_uint32_t( s_log_frag_size);
	PRINT_uint32_t( s_blocks_per_group);
	PRINT_uint32_t( s_frags_per_group);
	PRINT_uint32_t( s_inodes_per_group);
	PRINT_uint32_t( s_mtime);
	PRINT_uint32_t( s_wtime);
	PRINT_uint16_t( s_mnt_count);
	PRINT_uint16_t( s_max_mnt_count);
	PRINT_uint16_t( s_magic);
	PRINT_uint16_t( s_state);
	PRINT_uint16_t( s_errors);
	PRINT_uint16_t( s_minor_rev_level);
	PRINT_uint32_t( s_lastcheck);
	PRINT_uint32_t( s_checkinterval);
	PRINT_uint32_t( s_creator_os);
	PRINT_uint32_t( s_rev_level);
	PRINT_uint16_t( s_def_resuid);
	PRINT_uint16_t( s_def_resgid);

// EXT2_DYNAMIC_REV Specific --

	PRINT_uint32_t( s_first_ino);
	PRINT_uint16_t( s_inode_size);
	PRINT_uint16_t( s_block_group_nr);
	PRINT_uint32_t( s_feature_compat);
	PRINT_uint32_t( s_feature_incompat);
	PRINT_uint32_t( s_feature_ro_compat);
// XXX:	PRINT_uint8_t( s_uuid[16]);
// XXX:	PRINT_uint8_t( s_volume_name[16]);
// XXX:	PRINT_uint8_t( s_last_mounted[64]);
	PRINT_uint32_t( s_algo_bitmap);

//  Performance Hints --

	PRINT_uint8_t( s_prealloc_blocks);
	PRINT_uint8_t( s_prealloc_dir_blocks);
	PRINT_uint16_t( xs_alignment);
	//(alignment)

// Journaling Support --

//XXX:	PRINT_uint8_t( s_journal_uuid[16]);
	PRINT_uint32_t( s_journal_inum);
	PRINT_uint32_t( s_journal_dev);
	PRINT_uint32_t( s_last_orphan);

//  Directory Indexing Support --

//XXX:	PRINT_uint32_t( s_hash_seed[4]);
	PRINT_uint8_t( s_def_hash_version);
//XXX:	PRINT_uint8_t( xs_padding[3]); // - reserved for future expansion

//  Other options --

	PRINT_uint32_t( s_default_mount_options);
	PRINT_uint32_t( s_first_meta_bg);
//	PRINT_uint8_t( s_unused_padding[760]); // 760	Unused - reserved for future revisions

	return 0;
}

#undef ACC
#define ACC bgd

int sprint_bg_desc_t(bg_desc_ext2_t *bgd, char* buf)
{

	char *p = buf;

	PRINT_uint32_t( bg_block_bitmap);
	PRINT_uint32_t( bg_inode_bitmap);
	PRINT_uint32_t( bg_inode_table);
	PRINT_uint16_t( bg_free_blocks_count);
	PRINT_uint16_t( bg_free_inodes_count);
	PRINT_uint16_t( bg_used_dirs_count);
	PRINT_uint16_t( bg_pad);

//XXX:  PRINT_uint8_t( bg_reserved[12]) ;

	return 0;
}

#undef ACC
#define ACC inod

int sprint_inode_t(inode_ext2_t *inod, char* buf)
{

	char *p = buf;

	PRINT_uint16_t( i_mode);
	PRINT_uint16_t( i_uid);
	PRINT_uint32_t( i_size);
	PRINT_uint32_t( i_atime);
	PRINT_uint32_t( i_ctime);
	PRINT_uint32_t( i_mtime);
	PRINT_uint32_t( i_dtime);
	PRINT_uint16_t( i_gid);
	PRINT_uint16_t( i_links_count);
	PRINT_uint32_t( i_blocks);
	PRINT_uint32_t( i_flags);
	PRINT_uint32_t( i_osd1);
//XXX:  PRINT_uint32_t( i_block[15]);
	PRINT_uint32_t( i_generation);
	PRINT_uint32_t( i_file_acl);
	PRINT_uint32_t( i_dir_acl);
	PRINT_uint32_t( i_faddr);
//XXX:  PRINT_uint8_t( i_osd2[12]);

	return 0;
}

#endif


void test_read_write(file_t* dev_file)
{

	const int buf_size = 16 * 1024;

	const uint32_t len1 = 137;
	const uint32_t len2 = 111;

	uint32_t offset_a = 19;

	uint32_t key;

	printf("test_read: len1 = %d len2 = %d\n", len1, len2);

	char* buf1 = (char*) malloc(buf_size);
	char* buf2 = (char*) malloc(buf_size);

	char* out_buf1 = (char*) malloc(buf_size);
	char* out_buf2 = (char*) malloc(buf_size);

	memset(buf1, 0, buf_size);
	memset(buf2, 0, buf_size);

	ASSERT(buf1);
	ASSERT(buf2);

	char* pbuf1 = buf1;
	char* pbuf2 = buf2;

	size_t offs;

	size_t loffs = 0;

	uint32_t cnt1 = offset_a;
	uint32_t cnt2 = 0;

	while (cnt2 < len2)
	{
		dev_file->f_fops->llseek(dev_file, cnt1, 0);
		int nrd = dev_file->f_fops->read(dev_file, pbuf1, len1, &offs );

		ASSERT(nrd == len1);

		pbuf1 += len1;
		cnt1 += len1;
		++cnt2;
	}

	ASSERT(pbuf1 - buf1 == len1 * len2);

	cnt1 = offset_a;
	cnt2 = 0;

	while (cnt2 < len1)
	{
		dev_file->f_fops->llseek(dev_file, cnt1, 0);
		int nrd = dev_file->f_fops->read(dev_file, pbuf2, len2, &offs );

		ASSERT(nrd == len2);

		pbuf2 += len2;
		cnt1 += len2;
		++cnt2;
	}

	ASSERT(pbuf2 - buf2 == len1 * len2);

	int i;
	for(i = 0; i < len1 * len2; ++i)
	{
		//outb_printf("i = %d ", i);
		ASSERT(buf1[i] == buf2[i]);
	}

	printf("Test read ok.\n");


	offset_a = 512 * 1024 + 17;

	//memcpy(out_buf1, buf1, buf_size);
	//memcpy(out_buf2, buf2, buf_size);

	for(i = 0; i < buf_size; ++i)
	{
		uint8_t val = (rand() >> 8) & 0xff;
		out_buf1[i] = val;
		out_buf2[i] = val;
	}

	cnt1 = offset_a;
	cnt2 = 0;

	pbuf1 = out_buf1;

	while (cnt2 < len2)
	{
		dev_file->f_fops->llseek(dev_file, cnt1, 0);
		uint32_t nwrt = dev_file->f_fops->write(dev_file, pbuf1, len1, &offs );

		ASSERT(nwrt == len1);

		pbuf1 += len1;
		cnt1 += len1;
		++cnt2;
	}

	ASSERT(pbuf1 - out_buf1 == len1 * len2);

	cnt1 = offset_a + buf_size;
	cnt2 = 0;

	pbuf2 = out_buf2;

	while (cnt2 < len1)
	{
		dev_file->f_fops->llseek(dev_file, cnt1, 0);
		uint32_t nwrt = dev_file->f_fops->write(dev_file, pbuf2, len2, &offs );

		ASSERT(nwrt == len2);

		pbuf2 += len2;
		cnt1 += len2;
		++cnt2;
	}

	ASSERT(pbuf2 - out_buf2 == len1 * len2);

	memset(buf1, 0xab, buf_size);
	memset(buf2, 0xcd, buf_size);

	dev_file->f_fops->llseek(dev_file, offset_a, 0);
	int nrd = dev_file->f_fops->read(dev_file, buf1, len1 * len2, &offs);

	ASSERT(nrd == len1 * len2);

	dev_file->f_fops->llseek(dev_file, offset_a + buf_size, 0);
	nrd = dev_file->f_fops->read(dev_file, buf2, len1 * len2, &offs);

	ASSERT(nrd == len1 * len2);

	for(i = 0; i < len1 * len2; ++i)
	{
		//outb_printf("i = %d :", i);
		ASSERT(buf1[i] == buf2[i]);
	}

	outb_printf("\n");
	printf("Test write ok.\n");



	free(out_buf2);
	free(out_buf1);

	free(buf2);
	free(buf1);
}

#define SB_PRINT_FIELD(sb, sb_field) printf("%s = %d\n", #sb_field, sb->sb_field)

int print_sb_ext2(superblock_ext2_t* sb)
{
	SB_PRINT_FIELD(sb, s_inodes_count);
	SB_PRINT_FIELD(sb, s_blocks_count);
	SB_PRINT_FIELD(sb, s_first_data_block);
	SB_PRINT_FIELD(sb, s_log_block_size);
	SB_PRINT_FIELD(sb, s_inodes_per_group);
	SB_PRINT_FIELD(sb, s_blocks_per_group);
	SB_PRINT_FIELD(sb, s_inode_size);

	return 0;
}

#define BGD_PRINT_FIELD(bgd, bgd_field) printf("%s = %d\n", #bgd_field, bgd->bgd_field)

int print_bgdesc_ext2(bg_desc_ext2_t* pbgdesc)
{
	BGD_PRINT_FIELD(pbgdesc, bg_block_bitmap);
	BGD_PRINT_FIELD(pbgdesc, bg_inode_bitmap);
	BGD_PRINT_FIELD(pbgdesc, bg_inode_table);
	BGD_PRINT_FIELD(pbgdesc, bg_free_blocks_count);
	BGD_PRINT_FIELD(pbgdesc, bg_free_inodes_count);
	BGD_PRINT_FIELD(pbgdesc, bg_used_dirs_count);

	return 0;
}


void test_ide_rw_blk(file_t* dev_file)
{

	const int out_buf_len = 16 * 1024;
	const int size_sb = 1024;
	const int offset_sb = 1024;

	uint32_t key;

	test_read_write(dev_file);

}

int init_superblock_ext2(file_t* dev_file)
{
	const int size_sb = SIZE_SB;
	const int offset_sb = OFFSET_SB;

	gsb_ext2 = (superblock_ext2_t*) malloc(sizeof(superblock_ext2_t));

	uint32_t offs;
	dev_file->f_fops->llseek(dev_file, offset_sb, 0);
	int nrd = dev_file->f_fops->read(dev_file, (char*)gsb_ext2, size_sb, &offs);
	ASSERT(nrd == size_sb);

	return 0;
}

int init_ext2_system(file_t* dev_file)
{

	// superblock

	init_superblock_ext2(dev_file);

	g_blocks_per_group_ext2 = gsb_ext2->s_blocks_per_group;

	print_sb_ext2(gsb_ext2);

	g_ext2_blocksize = 1024 << (gsb_ext2->s_log_block_size);

	printf("global_ext2_blocksize = %d\n", g_ext2_blocksize);


	// block group descriptor 0

	bg_desc_ext2_t *pbgdesc = (bg_desc_ext2_t*) malloc(sizeof(bg_desc_ext2_t));

	read_bgdesc_ext2(dev_file, 0, pbgdesc);

	printf("\n");

	print_bgdesc_ext2(pbgdesc);

	free(pbgdesc);

	// init global root inode

	g_root_inode_ext2 = (inode_ext2_t*) malloc(sizeof(inode_ext2_t));

	read_inode_ext2(dev_file, 2, g_root_inode_ext2);

	uint32_t root_inode_blks = g_root_inode_ext2->i_blocks;

	printf("root_inode_blks = %d\n", root_inode_blks);
	printf("root_inode size = %d\n", g_root_inode_ext2->i_size);

#if 0
	printf("Testing get_indirect_blocks...\n");
	test_get_indirect_blocks();

	printf("Test ok.\n");
#endif


}


int read_bgdesc_ext2(file_t* dev_file, uint32_t bg_index, bg_desc_ext2_t* bg_desc)
{
	int nrd = -1;
	uint32_t offs_dummy;
	uint32_t offset_bg_index = OFFSET_SB + SIZE_SB;

	offset_bg_index += bg_index * sizeof(bg_desc_ext2_t);

	dev_file->f_fops->llseek(dev_file, offset_bg_index, 0);
	nrd = dev_file->f_fops->read(dev_file, (char*) bg_desc, sizeof(bg_desc_ext2_t), &offs_dummy);

	ASSERT(nrd == sizeof(bg_desc_ext2_t));

	return nrd;

}

int read_inode_ext2(file_t* dev_file, uint32_t inode_index, inode_ext2_t* pinode)
{
	int nrd = -1;

	uint32_t inode_index0 = inode_index - 1;

	uint32_t inode_bgrp_index = inode_index0 / gsb_ext2->s_inodes_per_group;
	uint32_t inode_bgrp_local_index = inode_index0 % gsb_ext2->s_inodes_per_group;

	bg_desc_ext2_t bgd_local;

	read_bgdesc_ext2(dev_file, inode_bgrp_index, &bgd_local);

	uint32_t inode_start_blk = bgd_local.bg_inode_table;

	uint32_t offs = inode_start_blk * g_ext2_blocksize + inode_bgrp_local_index * sizeof(inode_ext2_t);

	uint32_t offs_dummy;

	//printf("read_inode_ext2: offs = %d\n", offs);


	dev_file->f_fops->llseek(dev_file, offs, 0);
	nrd = dev_file->f_fops->read(dev_file, (char*) pinode, sizeof(inode_ext2_t), &offs_dummy);

	return nrd;

}

int get_indirect_blocks(uint32_t offset, uint32_t* index_arr, uint32_t *mode)
{
	const int direct_blks = 12;
	int links_per_blk = g_ext2_blocksize / sizeof(uint32_t);

	//outb_printf("get_indirect_blocks: offset = %d\n", offset);

	uint32_t offset_in_blks = offset / g_ext2_blocksize;
	uint32_t offset_in_blks_old = offset_in_blks;

	uint32_t limits[4];
	uint32_t index[4];

	uint32_t dd = 1;

	limits[0] = 12;
	dd *= links_per_blk;
	limits[1] = limits[0] + dd;
	dd *= links_per_blk;
	limits[2] = limits[1] + dd;
	dd *= links_per_blk;
	limits[3] = limits[2] + dd;
	memset(index, 0, sizeof(index));

	int i = 0;

	while (offset_in_blks >= limits[i])
	{
		++i;
	}

	*mode = i;

	int j = i;
	offset_in_blks -= (i > 0 ? limits[i-1]: 0);
/*
	while (j > 0)
	{
		index[i-j+1] = offset_in_blks / powers[j-1];
		offset_in_blks -= index[i-j+1] * powers[j-1];
		--j;
	}
*/

	while (j > 0)
	{
		index[j] = offset_in_blks % links_per_blk;
		offset_in_blks -= index[j];
		offset_in_blks /= links_per_blk;
		--j;
	}

	index[0] = (i == 0) ? offset_in_blks : 11 + i;

	memcpy(index_arr, &index[0], sizeof(index));

	//outb_printf("get_indirect_blocks: %d (%d %d %d %d)\n",
	//		offset_in_blks_old, index[0], index[1], index[2], index[3]);

	//uint32_t key = getc(0);

	return *mode;

}

int test_get_indirect_blocks()
{
	uint32_t offset;

	uint32_t offset_raw;

	uint32_t limits[4];
	uint32_t index[4];
	uint32_t powers[4];

	int links_per_blk = g_ext2_blocksize / sizeof(uint32_t);

	powers[0] = 1;
	int i = 1;
	while (i < 4)
	{
		powers[i] = links_per_blk * powers[i-1];
		++i;
	}

	limits[0] = 12;
	limits[1] = limits[0] + powers[1];
	limits[2] = limits[1] + powers[2];
	limits[3] = limits[2] + powers[3];
	memset(index, 0, sizeof(index));

	uint32_t limits_old = 0;

	int crs = 0;

	for(i = 0; i < 4; ++i)
	{
		int j;
		printf("\ntesting: i = %d ", i);
		for(j = 0; j + limits_old < limits[i]; ++j)
		{
			uint32_t mode;
			offset = (limits_old + j) * g_ext2_blocksize;
			offset_raw = limits_old + j;

			if (!offset && j)
			{
				printf("\noffset overflow at i = %d j = %d\n", i, j);
				break;
			}

			get_indirect_blocks(offset, &index[0], &mode);

			if (j % (64 * 1024) == 0)
			{
				printf(".");
				++crs;
				if (crs == 70)
				{
					printf("\n");
					crs = 0;
				}
			}


			if (mode != i)
			{
				outb_printf("mode != i at: i = %d, j = %d : ", i, j);
				uint32_t key = getc(0);
			}

			uint32_t k = 1;
			uint32_t offset_synth = index[k];
			++k;
			while (k <= mode)
			{
				offset_synth = offset_synth * powers[1] + index[k];
				++k;
			}
			offset_synth += ((mode == 0) ? index[0]: limits[mode-1]);


			if (offset_synth != offset_raw)
			{
				outb_printf("offset_synth != offset_raw at: i = %d, j = %d : ", i, j);
				uint32_t key = getc(0);
			}

		}
		limits_old = limits[i];
	}

	return 0;

}

int read_file_ext2(file_t* dev_file, inode_ext2_t *pinode, char* buf, uint32_t count, uint32_t offset)
{
	uint32_t pinode_size = pinode->i_size;
	uint32_t pinode_blks = pinode->i_blocks;

	char* pbuf = buf;

	uint32_t nrd_total = 0;

	while (count > 0)
	{

		uint32_t index[4];
		uint32_t mode = 0;

		uint32_t blk_num;

		get_indirect_blocks(offset, &index[0], &mode);
		if (mode == 0)
		{
			blk_num = pinode->i_block[index[0]];
		}
		else if (mode > 0)
		{
			blk_num = pinode->i_block[index[0]];
			int j = 1;
			char* aux_blk = (char*) malloc(g_ext2_blocksize);

			uint32_t offs_dummy;

			do
			{
				dev_file->f_fops->llseek(dev_file, g_ext2_blocksize * blk_num , 0);
				int nrd = dev_file->f_fops->read(dev_file, aux_blk, g_ext2_blocksize, &offs_dummy);

				blk_num = *(uint32_t*)&aux_blk[index[j] * sizeof(uint32_t)];

				--mode;
				++j;
			}
			while (mode > 0);

			free(aux_blk);
		}



		uint32_t in_blk_offset = offset % g_ext2_blocksize;

		uint32_t to_read = min(g_ext2_blocksize - in_blk_offset, count);

		//printf("read_file_ext2: to_read = %d, blk_num = %d, in_blk_offset = %d\n",
		//	to_read, blk_num, in_blk_offset);

		//uint32_t key = getc(0);

		uint32_t offs_dummy;
		dev_file->f_fops->llseek(dev_file, blk_num * g_ext2_blocksize + in_blk_offset, 0);
		int nrd = dev_file->f_fops->read(dev_file, pbuf, to_read, &offs_dummy);

		ASSERT(nrd == to_read);

		offset += nrd;

		nrd_total += nrd;
		pbuf += nrd;
		count -= nrd;

	}
	return nrd_total;
}

int readdir_ext2(file_t *dev_file, inode_ext2_t *pinode, dir_entry_ext2_t* dir_entry,
		char* namebuf, uint32_t *dir_offset)
{
	dir_entry_ext2_t current_entry;

	read_file_ext2(dev_file, pinode, (char*)&current_entry, sizeof(dir_entry_ext2_t), *dir_offset);

	uint32_t name_len = current_entry.name_len;
	uint32_t rec_len = current_entry.rec_len;

	//printf("rec_len = %d : name_len = %d\n", rec_len, name_len);

	read_file_ext2(dev_file, pinode, namebuf, name_len, *dir_offset + sizeof(dir_entry_ext2_t));

	namebuf[name_len] = 0;

	memcpy(dir_entry, &current_entry, sizeof(dir_entry_ext2_t));

	*dir_offset += rec_len;

	return 0;
}

#define PPE2_FILE_FOUND	1
#define PPE2_REG_FILE_FOUND	2

int parse_path_ext2(file_t* dev_file, char* path, inode_ext2_t *pinode)
{

	uint32_t dir_offset = 0;

	dir_entry_ext2_t akt_entry;

	int argc;
	char* argv[MAX_PATH_COMPONENTS];

	char namebuf[128];

	parse_buf(path, strlen(path), "/", &argc, argv);


	int i;


	for(i = 0; i < argc; ++i)
	{
		outb_printf("parse_path_ext2: argv[%d] = %s\n", i, argv[i]);
	}


	inode_ext2_t akt_inode;
	memcpy(&akt_inode, g_root_inode_ext2, sizeof(inode_ext2_t));

	i = 0;

	while (i < argc)
	{
		int nrd = -1;
		int found = 0;

		dir_offset = 0;

		outb_printf("parse_path_ext2: argv[%d] = %s\n", i, argv[i]);
		do
		{

			uint32_t dir_offset_old = dir_offset;

			nrd = readdir_ext2(dev_file, &akt_inode, &akt_entry, namebuf, &dir_offset);

			outb_printf("namebuf = >%s<\n", namebuf);

			if (!strcmp(namebuf, argv[i]))
			{
					found = PPE2_FILE_FOUND;
					break;
			}

		}
		while(dir_offset < akt_inode.i_size);

		if (found)
		{
			uint32_t akt_inode_index = akt_entry.inode;

			outb_printf("parse_path_ext2: akt_inode_index = %d\n", akt_inode_index);

			read_inode_ext2(dev_file, akt_inode_index, &akt_inode);

			if (akt_inode.i_mode & EXT2_S_IFREG)
			{
				found = PPE2_REG_FILE_FOUND;
				++i;
				outb_printf("parse_path_ext2: regular file found.\n");
				break;
			}
		}
		else
		{
			printf("parse_path_ext2: could not resolve %s at %s.\n", path, argv[i]);
			return -1;
		}
		++i;
	}

	if (i < argc)
	{
		printf("parse_path_ext2: is not a directory: %s\n", argv[i]);
		return -1;
	}

	memcpy(pinode, &akt_inode, sizeof(inode_ext2_t));

	return 0;
}

int display_directory_ext2(file_t* dev_file, inode_ext2_t* pinode)
{

	uint32_t dir_offset = 0;

	dir_entry_ext2_t akt_entry;
	inode_ext2_t aux_inode;

	char namebuf[128];

	int nrd = -1;

	//printf("display_directory_ext2: pinode->i_blocks = %d : ", pinode->i_blocks);
	//printf("pinode->i_size = %d\n", pinode->i_size);

	uint32_t pinode_size = pinode->i_size;

	do
	{
		nrd = readdir_ext2(dev_file, pinode, &akt_entry, namebuf, &dir_offset);

		uint32_t akt_inode_index = akt_entry.inode;
		int is_dir = 0;
		uint32_t akt_size = 0;

		if (akt_inode_index)
		{
			read_inode_ext2(dev_file, akt_inode_index, &aux_inode);
			is_dir = aux_inode.i_mode & EXT2_S_IFDIR;

			akt_size = aux_inode.i_size;
		}

		printf("%s : %c : %d bytes : inode = %d : rec_len = %d : dir_offset = %d\n",
				namebuf, is_dir ? 'd' : 'r', akt_size, akt_entry.inode, akt_entry.rec_len,
						dir_offset);
	}
	while(dir_offset < pinode_size);

	return 0;
}

int display_regular_file_ext2(file_t* dev_file, inode_ext2_t* pinode)
{

	const int aux_buf_size = 129;
	char auxbuf[aux_buf_size];

	uint32_t rest = pinode->i_size;
	uint32_t offset = 0;
	uint32_t dummy_offset;

	uint32_t nrd_total = 0;
	int nrd = 0;

	while (rest > 0)
	{
		uint32_t to_read = min(aux_buf_size - 1, rest);
		nrd = read_file_ext2(dev_file, pinode, auxbuf, to_read, offset);

		if (nrd < 0)
		{
			printf("\n\ndisplay_regular_file_ext2: break: nrd = %d\n", nrd);
			break;
		}

		auxbuf[nrd] = 0x0;
		printf("%s", auxbuf);

		nrd_total += nrd;
		rest -= nrd;
		offset += nrd;
	}


	return nrd >= 0 ? nrd_total: nrd;
}


int display_inode_ext2(file_t* dev_file, inode_ext2_t* pinode)
{
	if (pinode->i_mode & EXT2_S_IFDIR)
	{
		display_directory_ext2(dev_file, pinode);
	}
	else if (pinode->i_mode & EXT2_S_IFREG)
	{
		display_regular_file_ext2(dev_file, pinode);
	}
	return 0;
}

