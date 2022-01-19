#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "nice_sign.h"
#include "nice_hash.h"
#include "cJSON/cJSON.h"

typedef struct Node {
	struct Node *next;

	char *key;
	char *value;
} Node;

Node *createNode(char *key, char *value);
static int Node_strcmp(const Node *s1, const Node *s2);

typedef struct Node Lnode;
Lnode *insertList(Lnode *head, Node *item);
static char *Lnode2str(Lnode *head, char sep, char keyvalsep);
static int LnodeStrlen(Lnode *head);
void FreeLnode(Lnode *head);

void swap_char(char *str);
static char *cJSON2str(cJSON *item);
static char *cJSONArray2str(cJSON *arrayitem, char sep, char keyvalsep);
static char *cJSONObject2str(cJSON *objectitem, char sep, char keyvalsep);

const char *nice_sign(const char *source_str, const char *dev_str, const char *salt_str, const unsigned int sign_ver) {
	char *      privateKey 		= "4b7aa72afedaf5e35d05898de4c1df3e";
	char * 		catStr 			= NULL;
	char 		uuid[33] 		= {0};
	char 		hashid[33] 		= {0};
	char * 		SignStr 		= NULL;
	static char sign[33] 		= {0};

	switch (sign_ver & 0xff) {
	case 2: 		privateKey 	= "11b9ee698954721dfbd446072c7bd437"; 	break;
	case 1:
	default: 		break;
	}

	// dev_str 前32位做为uuid
	strncpy(uuid, dev_str, 32);
	// 计算catStr  (slat + md5(uuid) + 私钥)
	catStr = (char *)malloc((strlen(salt_str)+32+32+1) * sizeof(char));
	if (!catStr) return 0;
	memset(catStr, 0, (strlen(salt_str)+32+32+1));
	strcpy(catStr, salt_str);
	strcat(catStr, nice_md5(uuid));
	strcat(catStr, privateKey);

	// 对hashid = md5(catStr)
	strcpy(hashid, nice_md5(catStr));
	free(catStr); catStr = NULL;

	// 计算SignStr
	cJSON *json = cJSON_Parse(source_str);
	if (!json) { return NULL; } //printf("Error before: [%s]\n",cJSON_GetErrorPtr()); return NULL; 
	SignStr = cJSON2str(json);
	cJSON_Delete(json);

	// SignStr + hashid
	catStr = (char *)malloc((strlen(SignStr)+32+1) * sizeof(char));
	if (!catStr) return 0;
	memset(catStr, 0, (strlen(SignStr)+32+1));
	strcpy(catStr, SignStr);
	free(SignStr); SignStr = NULL;
	strcat(catStr, hashid);
	// sha1(SignStr + hashid) 取第4位后的32位
	strncpy(sign, nice_sha1(catStr)+3, 32);
	sign[32] = '\0';
	free(catStr); catStr = NULL;

	return sign;
}

const char *nice_sign_v3(const char *source_str, const char *dev_str, const char *salt_str) {
        char    *privateKey     = "8a5f746c1c9c99c0b458e1ed510845e5";
        char    *catStr         = NULL;
        char    hashid[33]      = {0};
        char    *SignStr        = NULL;
        char    devStr[33]      = {0};
	static char sign[33]    = {0};
        int     i               = 0;

        strcpy(devStr,dev_str);

        //1.交换deviceId
        swap_char(devStr);

        //2.计算hash_id = md5(salt + dev_str + privateKey)
        catStr = (char *)malloc((strlen(source_str) + 101) * sizeof(char)); //申请一块空间
        if (!catStr) return 0;
        strcpy(catStr, salt_str);
        strcat(catStr, nice_md5(devStr));
        strcat(catStr, privateKey);
        strcpy(hashid, nice_md5(catStr));

        //3.交换hashid
        swap_char(hashid);

        //4.计算json_str=c_json_encode(c_json_decode(json_data))
        cJSON *json = cJSON_Parse(source_str);
        if (!json) { return NULL; }
        SignStr = cJSON2str(json);
        cJSON_Delete(json);

        //5.compact
        for(i = 0;i < (strlen(SignStr) / 2); i++){
                catStr[i] = (SignStr[i*2] & 0xF0) | (SignStr[i*2+1] & 0x0F);
        }
        free(SignStr);

        //6.去8-40位,并执行sha1算法,计算sha_id = sha1(json_str + hash_id)
        strncpy(catStr + i, hashid, 32);
        catStr[i+32] = '\0';
        strncpy(sign, nice_sha1(catStr) + 8, 32);

        free(catStr);

        //swap 
        swap_char(sign);
        return sign;
}

void swap_char(char *str) {
    char c;
    int i;
    int len = strlen(str)/2;
    for(i=0;i<len;i++){
        c = *str;
        *str = *(str+len);
        *(str+len) = c;
        str++;
    }
}

static char *cJSON2str(cJSON *item) {
	char *out = NULL;
	if (!item) return 0;
	switch ((item->type) & 0xff) {
		case cJSON_NULL:
		case cJSON_False:
		case cJSON_True:
		case cJSON_Number: 		out = cJSON_Print(item); 				break;
		case cJSON_String: 		
			out = (char *)malloc((strlen(item->valuestring)+1) * sizeof(char));
			if (!out) return 0;
			strcpy(out, item->valuestring); 							break;
		case cJSON_Array: 		out = cJSONArray2str(item, '=', '&'); 	break;
		case cJSON_Object: 		out = cJSONObject2str(item, '=', '&'); 	break;
	}
	return out;
}

static char *cJSONArray2str(cJSON *arrayitem, char sep, char keyvalsep) {
	char *out = NULL;
	if (!arrayitem) return 0;
	int i, l;
	Lnode *h = NULL; 	// 链表用于排序
	for (i = 0, l = cJSON_GetArraySize(arrayitem); i < l; i++) {
		cJSON *subitem = cJSON_GetArrayItem(arrayitem, i);
		char key[11] = {0}; 	// int 最大10位 
		sprintf(key, "%d", i);
		char *value = cJSON2str(subitem);
		h = insertList(h, createNode(key, value));
		free(value);
	}
	out = Lnode2str(h, sep, keyvalsep);
	FreeLnode(h);
	return out;
}

static char *cJSONObject2str(cJSON *objectitem, char sep, char keyvalsep) {
	char *out = NULL;
	if (!objectitem) return 0;
	int i, l;
	Lnode *h = NULL;
	for (i = 0, l = cJSON_GetArraySize(objectitem); i < l; i++) {
		cJSON *subitem = cJSON_GetArrayItem(objectitem, i);
		char *value = cJSON2str(subitem);
		h = insertList(h, createNode(subitem->string, value));
		free(value);
	}
	out = Lnode2str(h, sep, keyvalsep);
	FreeLnode(h);
	return out;
}

Node *createNode(char *key, char *value) {
	Node *node = (Node *)malloc(sizeof(Node));
	if (!node) return 0;
	node->next = NULL;
	if (key) {
		node->key = (char *)malloc((strlen(key)+1)*sizeof(char));
		strcpy(node->key, key);
	}
	if (value) {
		node->value = (char *)malloc((strlen(value)+1)*sizeof(char));
		strcpy(node->value, value);
	}
	return node;
}

static int Node_strcmp(const Node *s1, const Node *s2) {
	return strcmp(s1->key, s2->key);
}

Lnode *insertList(Lnode *head, Node *item) {
	if (!item) return head;

	Lnode *current = head;
	// 没有元素
	if (current == NULL) {
		head = item;
		return head;
	}
	if (!(Node_strcmp(current, item) < 0)) {
		item->next = current;
		head = item;
		return head;
	}

	while (current->next && Node_strcmp(current->next, item) < 0) {
		current = current->next;
	}
	item->next = current->next;
	current->next = item;
	return head;
}

static char *Lnode2str(Lnode *head, char sep, char keyvalsep) {
	int 	len 		= LnodeStrlen(head);
	char * 	lnodeStr 	= (char *)malloc((len+1) * sizeof(char));
	if (!lnodeStr) return 0;
	memset(lnodeStr, 0, (len+1));
	Node * 	p 			= head;
	int 	i 			= 0;
	while (p) {
		// key
		strcpy(lnodeStr + i, p->key); i += strlen(p->key);
		// sep
		*(lnodeStr + i) = sep; i++;
		// value
		strcpy(lnodeStr + i, p->value); i += strlen(p->value);
		// keyvalsep
		if (p->next) {
			*(lnodeStr + i) = keyvalsep; i++;
		}
		p = p->next;
	}
	return lnodeStr;
}

static int LnodeStrlen(Lnode *head) {
	Node * 		p 			= head;
	int 		len 		= 0;
	while (p) {
		len += (strlen(p->key) + 1 + strlen(p->value));
		if (p->next) {
			len += 1;
		}
		p = p->next;
	}
	return len;
}

void FreeLnode(Lnode *head) {
	Lnode *p = head;
	while (p) {
//		printf("%s %s\n", p->key, p->value);
		p=p->next;
		free(head->key);
		free(head->value);
		free(head);
		head=p;
	}
}
