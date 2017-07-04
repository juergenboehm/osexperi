
#ifndef __fs_ext2
#define __fs_ext2


typedef struct superblock_s {
/*0	4 */ uint32_t	s_inodes_count;
/*4	4	*/ uint32_t s_blocks_count;
/*8	4 */ uint32_t s_r_blocks_count;
/*12 4 */ uint32_t	s_free_blocks_count;
/*16	4	*/ uint32_t s_free_inodes_count;
/*20	4	*/ uint32_t s_first_data_block;
/*24	4	*/ uint32_t s_log_block_size;
/*28	4	*/ uint32_t s_log_frag_size;
/*32	4	*/ uint32_t s_blocks_per_group;
/*36	4	*/ uint32_t s_frags_per_group;
/*40	4	*/ uint32_t s_inodes_per_group;
/*44	4	*/ uint32_t s_mtime;
/*48	4	*/ uint32_t s_wtime;
/*52	2	*/ uint16_t s_mnt_count;
/*54	2	*/ uint16_t s_max_mnt_count;
/*56	2	*/ uint16_t s_magic;
/*58	2	*/ uint16_t s_state;
/*60	2	*/ uint16_t s_errors;
/*62	2	*/ uint16_t s_minor_rev_level;
/*64	4	*/ uint32_t s_lastcheck;
/*68	4	*/ uint32_t s_checkinterval;
/*72	4	*/ uint32_t s_creator_os;
/*76	4	*/ uint32_t s_rev_level;
/*80	2	*/ uint16_t s_def_resuid;
/*82	2	*/ uint16_t s_def_resgid;

// EXT2_DYNAMIC_REV Specific --

/*84	4	*/ uint32_t s_first_ino;
/*88	2	*/ uint16_t s_inode_size;
/*90	2	*/ uint16_t s_block_group_nr;
/*92	4	*/ uint32_t s_feature_compat;
/*96	4	*/ uint32_t s_feature_incompat;
/*100	4	*/ uint32_t s_feature_ro_compat;
/*104	16	*/ uint8_t s_uuid[16];
/*120	16	*/ uint8_t s_volume_name[16];
/*136	64	*/ uint8_t s_last_mounted[64];
/*200	4	*/ uint32_t s_algo_bitmap;

//  Performance Hints --

/*204	1	*/ uint8_t s_prealloc_blocks;
/*205	1	*/ uint8_t s_prealloc_dir_blocks;
/*206	2	*/ uint16_t xs_alignment; //(alignment)

// Journaling Support --

/*208	16	*/ uint8_t s_journal_uuid[16];
/*224	4	*/ uint32_t s_journal_inum;
/*228	4	*/ uint32_t s_journal_dev;
/*232	4	*/ uint32_t s_last_orphan;

//  Directory Indexing Support --

/*236	4 x 4	*/ uint32_t s_hash_seed[4];
/*252	1	*/ uint8_t s_def_hash_version;
/*253	3	*/ uint8_t xs_padding[3]; // - reserved for future expansion

//  Other options --

/*256	4	*/ uint32_t s_default_mount_options;
/*260	4	*/ uint32_t s_first_meta_bg;
/*264	*/ uint8_t s_unused_padding[760]; // 760	Unused - reserved for future revisions
} superblock_t;


typedef struct bg_desc_s {
/* 0	4 */	uint32_t bg_block_bitmap;
/* 4	4 */	uint32_t bg_inode_bitmap;
/* 8	4 */	uint32_t bg_inode_table;
/* 12	2 */	uint16_t bg_free_blocks_count;
/* 14	2 */	uint16_t bg_free_inodes_count;
/* 16	2 */	uint16_t bg_used_dirs_count;
/* 18	2 */	uint16_t bg_pad;
/* 20	12 */	uint8_t  bg_reserved[12];
} bg_desc_t;


typedef struct inode_s {
/* 0	2	*/ uint16_t i_mode;
/* 2	2	*/ uint16_t i_uid;
/* 4	4	*/ uint32_t i_size;
/* 8	4	*/	uint32_t i_atime;
/* 12	4	*/	uint32_t i_ctime;
/* 16	4	*/	uint32_t i_mtime;
/* 20	4	*/	uint32_t i_dtime;
/* 24	2	*/ uint16_t i_gid;
/* 26	2	*/ uint16_t i_links_count;
/* 28	4	*/	uint32_t i_blocks;
/* 32	4	*/	uint32_t i_flags;
/* 36	4	*/	uint32_t i_osd1;
/* 40	15 x 4	*/	uint32_t i_block[15];
/* 100	4	*/	uint32_t i_generation;
/* 104	4	*/	uint32_t i_file_acl;
/* 108	4	*/	uint32_t i_dir_acl;
/* 112	4	*/	uint32_t i_faddr;
/* 116	12 */	uint8_t i_osd2[12];
} inode_t;

#endif
