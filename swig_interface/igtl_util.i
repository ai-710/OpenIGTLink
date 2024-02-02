%module igtlutil

%{
#include "Source/igtlutil/*.h"
%}

%include "stdint.i"

// Declare functions

// igtl_util header
#define IGTL_SCALAR_INT8      2
#define IGTL_SCALAR_UINT8     3
#define IGTL_SCALAR_INT16     4
#define IGTL_SCALAR_UINT16    5
#define IGTL_SCALAR_INT32     6
#define IGTL_SCALAR_UINT32    7
#define IGTL_SCALAR_FLOAT32   10
#define IGTL_SCALAR_FLOAT64   11
#define IGTL_SCALAR_COMPLEX   13


/** Byte order conversion macros */
#define BYTE_SWAP_INT16(S) (((S) & 0xFF) << 8 \
                            | (((S) >> 8) & 0xFF))
#define BYTE_SWAP_INT32(L) ((BYTE_SWAP_INT16 ((L) & 0xFFFF) << 16) \
                            | BYTE_SWAP_INT16 (((L) >> 16) & 0xFFFF))
#define BYTE_SWAP_INT64(LL) ((BYTE_SWAP_INT32 ((LL) & 0xFFFFFFFF) << 32) \
                             | BYTE_SWAP_INT32 (((LL) >> 32) & 0xFFFFFFFF))

%inline %{
int igtl_is_little_endian();
igtl_uint64 crc64(unsigned char *data, igtl_uint64 len, igtl_uint64 crc);
igtl_uint32 igtl_nanosec_to_frac(igtl_uint32 nanosec);
igtl_uint32 igtl_frac_to_nanosec(igtl_uint32 frac);
void igtl_message_dump_hex(FILE* stream, const void* message, int max_size);
igtl_uint32 igtl_get_scalar_size(int type);
%}


// igtl_bind 
#define IGTL_HEADER_TYPE_SIZE  12
#define IGTL_HEADER_NAME_SIZE  20

typedef unsigned char igtl_uint8;
typedef unsigned short igtl_uint16;
typedef unsigned int igtl_uint32;
typedef unsigned long long igtl_uint64;

typedef struct {
  char             type[IGTL_HEADER_TYPE_SIZE+1]; /* Data type (OpenIGTLink Device Type string) */
  char             name[IGTL_HEADER_NAME_SIZE+1]; /* Device name */
  igtl_uint64      size;                          /* Data size */
  void*            ptr;                           /* Pointer to the child message */
} igtl_bind_child_info;

typedef struct {
  igtl_uint16 ncmessages;
  igtl_bind_child_info *child_info_array;
  igtl_uint64 resol;
  igtl_uint8 request_all;
  igtl_uint8 status;
} igtl_bind_info;

%inline %{
void igtl_bind_init_info(igtl_bind_info * bind_info);
int igtl_bind_alloc_info(igtl_bind_info * bind_info, igtl_uint16 ncmessages);
int igtl_bind_free_info(igtl_bind_info * bind_info);
int igtl_bind_unpack(int type, void * byte_array, igtl_bind_info * info, igtl_uint64 size);
int igtl_bind_pack(igtl_bind_info * info, void * byte_array, int type);
igtl_uint64 igtl_bind_get_size(igtl_bind_info * info, int type);
igtl_uint64 igtl_bind_get_crc(igtl_bind_info * info, int type, void* bind_message);
%}

// igtl_capability
#define IGTL_CAPABILITY_HEADER_SIZE          4
typedef struct {
  igtl_uint32      ntypes;
  unsigned char ** typenames;
} igtl_capability_info;

%inline %{
void igtl_capability_init_info(igtl_capability_info * info);
int igtl_capability_alloc_info(igtl_capability_info * info, int ntypes);
int igtl_capability_free_info(igtl_capability_info * info);
igtl_uint32 igtl_capability_get_length(igtl_capability_info * info);
int igtl_capability_unpack(void * byte_array, igtl_capability_info * info, igtl_uint64 pack_size);
int igtl_capability_pack(igtl_capability_info * info, void * byte_array);
igtl_uint64 igtl_capability_get_crc(igtl_capability_info* info, void* capability);
%}


// igtl_colortable
#define IGTL_COLORTABLE_HEADER_SIZE    2

#define IGTL_COLORTABLE_INDEX_UINT8    3
#define IGTL_COLORTABLE_INDEX_UINT16   5
#define IGTL_COLORTABLE_MAP_UINT8      3
#define IGTL_COLORTABLE_MAP_UINT16     5
#define IGTL_COLORTABLE_MAP_RGB        19

typedef struct {
  igtl_int8    indexType;      /* Index Type: 3:uint8 5:uint16 */
  igtl_int8    mapType;        /* 3: uint8 5:uint16 19:RGB color */
} igtl_colortable_header;

%inline %{
igtl_uint64 igtl_colortable_get_table_size(igtl_colortable_header* header);
void igtl_colortable_convert_byte_order(igtl_colortable_header* header, void* table);
igtl_uint64 igtl_colortable_get_crc(igtl_colortable_header* header, void* table);
%}


// igtl_command
#define IGTL_COMMAND_HEADER_SIZE    138
#define IGTL_COMMAND_NAME_SIZE      128

typedef struct {
  igtl_uint32    commandId;        /* The unique ID of this command */
  igtl_uint8     commandName[IGTL_COMMAND_NAME_SIZE];  /* The name of this command */
  igtl_uint16    encoding;         /* Character encoding type as MIBenum value (defined by IANA). Default=3 */
                                   /* Please refer http://www.iana.org/assignments/character-sets for detail */
  igtl_uint32    length;           /* Length of command */
} igtl_command_header;

%inline %{
void igtl_command_convert_byte_order(igtl_command_header * header);
igtl_uint64 igtl_command_get_crc(igtl_command_header * header, void* command);
%}


// igtl_header
#define IGTL_HEADER_VERSION_1   1
#define IGTL_HEADER_VERSION_2   2
#define IGTL_HEADER_SIZE      58
#define IGTL_EXTENDED_HEADER_SIZE      12

#define IGTL_HEADER_TYPE_SIZE  12
#define IGTL_HEADER_NAME_SIZE  20

/* Following macros will be obsolete. Included for old programs*/
#define IGTL_HEADER_TYPESIZE  IGTL_HEADER_TYPE_SIZE
#define IGTL_HEADER_NAMESIZE  IGTL_HEADER_NAME_SIZE
#define IGTL_HEADER_DEVSIZE   IGTL_HEADER_NAME_SIZE

/* Device name prefix macro */
#define IGTL_TYPE_PREFIX_NONE     0
#define IGTL_TYPE_PREFIX_GET      1
#define IGTL_TYPE_PREFIX_STT      2
#define IGTL_TYPE_PREFIX_STP      3
#define IGTL_TYPE_PREFIX_RTS      4
#define IGTL_NUM_TYPE_PREFIX      5

typedef struct {
  igtl_uint16    header_version;          /* header version number */
  char           name[IGTL_HEADER_TYPE_SIZE];       /* data type name          */
  char           device_name[IGTL_HEADER_NAME_SIZE]; /* device name             */
  igtl_uint64    timestamp;        /* time stamp message      */
  igtl_uint64    body_size;        /* size of the body        */
  igtl_uint64    crc;              /* CRC                     */
} igtl_header;

typedef struct {
  igtl_uint16    extended_header_size;          /* size of extended header */
  igtl_uint16    meta_data_header_size;         /* size of the meta data header*/
  igtl_uint32    meta_data_size;                /* size of meta data */
  igtl_uint32    message_id;                    /* message id */
} igtl_extended_header;

typedef struct {
  igtl_uint16   key_size;
  igtl_uint16   value_encoding;
  igtl_uint32   value_size;
} igtl_metadata_header_entry;

%inline%{
void igtl_header_convert_byte_order(igtl_header* header);
void igtl_extended_header_convert_byte_order(igtl_extended_header * extended_header);
%}


// igtl_image header
#define IGTL_IMAGE_HEADER_VERSION       1
#define IGTL_IMAGE_HEADER_SIZE          72

/* Data type */
#define IGTL_IMAGE_DTYPE_SCALAR         1
#define IGTL_IMAGE_DTYPE_VECTOR         3

/* Scalar type */
#define IGTL_IMAGE_STYPE_TYPE_INT8      2
#define IGTL_IMAGE_STYPE_TYPE_UINT8     3
#define IGTL_IMAGE_STYPE_TYPE_INT16     4
#define IGTL_IMAGE_STYPE_TYPE_UINT16    5
#define IGTL_IMAGE_STYPE_TYPE_INT32     6
#define IGTL_IMAGE_STYPE_TYPE_UINT32    7
#define IGTL_IMAGE_STYPE_TYPE_FLOAT32   10
#define IGTL_IMAGE_STYPE_TYPE_FLOAT64   11

/* Endian */
#define IGTL_IMAGE_ENDIAN_BIG           1
#define IGTL_IMAGE_ENDIAN_LITTLE        2

/* Image coordinate system */
#define IGTL_IMAGE_COORD_RAS            1
#define IGTL_IMAGE_COORD_LPS            2

typedef struct {
  igtl_uint16    header_version;   
  igtl_uint8     num_components;  
  igtl_uint8     scalar_type;
  igtl_uint8     endian;           
  igtl_uint8     coord;            
  igtl_uint16    size[3];
  igtl_float32   matrix[12];
  igtl_uint16    subvol_offset[3];
  igtl_uint16    subvol_size[3];
} igtl_image_header;

%inline %{
igtl_uint64  igtl_image_get_data_size(igtl_image_header * header);
void igtl_image_set_matrix(float spacing[3], float origin[3],
                            float norm_i[3], float norm_j[3], float norm_k[3],
                            igtl_image_header * header);

void igtl_image_get_matrix(float spacing[3], float origin[3],
                            float norm_i[3], float norm_j[3], float norm_k[3],
                            igtl_image_header * header);

void igtl_image_set_matrix_4x4(float _matrix[4][4],igtl_image_header * header);
void igtl_image_get_matrix_4x4(float _matrix[4][4],igtl_image_header * header);
void igtl_image_convert_byte_order(igtl_image_header * header);
igtl_uint64 igtl_image_get_crc(igtl_image_header * header, void* image);
%}


//igtl_imgmeta
#define IGTL_IMGMETA_LEN_NAME         64
#define IGTL_IMGMETA_LEN_DEVICE_NAME  20
#define IGTL_IMGMETA_LEN_MODALITY     32
#define IGTL_IMGMETA_LEN_PATIENT_NAME 64
#define IGTL_IMGMETA_LEN_PATIENT_ID   64

typedef struct {
  char           name[IGTL_IMGMETA_LEN_NAME];                 /* name / description */
  char           device_name[IGTL_IMGMETA_LEN_DEVICE_NAME];   /* device name to query the IMAGE and COLORT */
  char           modality[IGTL_IMGMETA_LEN_MODALITY];         /* modality name */
  char           patient_name[IGTL_IMGMETA_LEN_PATIENT_NAME]; /* patient name */ 
  char           patient_id[IGTL_IMGMETA_LEN_PATIENT_ID];     /* patient ID (MRN etc.) */  
  igtl_uint64    timestamp;        /* scan time */
  igtl_uint16    size[3];          /* entire image volume size */ 
  igtl_uint8     scalar_type;      /* scalar type. see scalar_type in IMAGE message */
  igtl_uint8     reserved;
} igtl_imgmeta_element;

#define igtl_imgmeta_get_data_size(n)  ((n) * IGTL_IMGMETA_ELEMENT_SIZE)
#define igtl_imgmeta_get_data_n(size)  ((size) / IGTL_IMGMETA_ELEMENT_SIZE)

%inline%{
void igtl_imgmeta_convert_byte_order(igtl_imgmeta_element* metalist, int nitem);
igtl_uint64 igtl_imgmeta_get_crc(igtl_imgmeta_element* metalist, int nitem);
%}


// igtl_lbmeta 
#define IGTL_LBMETA_ELEMENT_SIZE          116

#define IGTL_LBMETA_LEN_NAME              64
#define IGTL_LBMETA_LEN_DEVICE_NAME       20
#define IGTL_LBMETA_LEN_OWNER             20

typedef struct {
  char           name[IGTL_LBMETA_LEN_NAME]; 
  char           device_name[IGTL_LBMETA_LEN_DEVICE_NAME];
  igtl_uint8     label;                      
  igtl_uint8     reserved;
  igtl_uint8     rgba[4];                    
  igtl_uint16    size[3];                     
  char           owner[IGTL_LBMETA_LEN_OWNER];
} igtl_lbmeta_element;

#define igtl_lbmeta_get_data_size(n)  ((n) * IGTL_LBMETA_ELEMENT_SIZE)
#define igtl_lbmeta_get_data_n(size)  ((size) / IGTL_LBMETA_ELEMENT_SIZE)

%inline %{
void igtl_lbmeta_convert_byte_order(igtl_lbmeta_element* metalist, int nitem);
igtl_uint64 igtl_lbmeta_get_crc(igtl_lbmeta_element* metalist, int nitem);
%}


// igtl_ndarray
#define IGTL_NDARRAY_HEADER_SIZE          2

/* Scalar type */
#define IGTL_NDARRAY_STYPE_TYPE_INT8      2
#define IGTL_NDARRAY_STYPE_TYPE_UINT8     3
#define IGTL_NDARRAY_STYPE_TYPE_INT16     4
#define IGTL_NDARRAY_STYPE_TYPE_UINT16    5
#define IGTL_NDARRAY_STYPE_TYPE_INT32     6
#define IGTL_NDARRAY_STYPE_TYPE_UINT32    7
#define IGTL_NDARRAY_STYPE_TYPE_FLOAT32   10
#define IGTL_NDARRAY_STYPE_TYPE_FLOAT64   11
#define IGTL_NDARRAY_STYPE_TYPE_COMPLEX   13

#define IGTL_NDARRAY_HOST_TO_NETWORK      0
#define IGTL_NDARRAY_NETWORK_TO_HOST      1

typedef struct {
  igtl_uint8     type;   /* Scalar type (2:int8 3:uint8 4:int16 5:uint16 6:int32
                            7:uint32 10:float32 11:float64 13:complex) */
  igtl_uint8     dim;    /* Dimension of array */
  igtl_uint16 *  size;   /* Array size */
  void *         array;
} igtl_ndarray_info;

%inline%{
void igtl_ndarray_init_info(igtl_ndarray_info * info);
int igtl_ndarray_alloc_info(igtl_ndarray_info * info, const igtl_uint16 * size);
int igtl_ndarray_free_info(igtl_ndarray_info * info);
int igtl_ndarray_unpack(int type, void * byte_array, igtl_ndarray_info * info, igtl_uint64 pack_size);
int igtl_ndarray_pack(igtl_ndarray_info * info, void * byte_array, int type);
igtl_uint64 igtl_ndarray_get_size(igtl_ndarray_info * info, int type);
igtl_uint64 igtl_ndarray_get_crc(igtl_ndarray_info * info, int type, void* byte_array);
%}


// igtl_point
#define  IGTL_POINT_ELEMENT_SIZE           136

#define IGTL_POINT_LEN_NAME              64
#define IGTL_POINT_LEN_GROUP_NAME        32
#define IGTL_POINT_LEN_OWNER             20

typedef struct {
  char         name[IGTL_POINT_LEN_NAME]; /* Name or description of the point */
  char         group_name[IGTL_POINT_LEN_GROUP_NAME]; /* Can be "Labeled Point", "Landmark", Fiducial", ... */
  igtl_uint8   rgba[4]; /* Color in R/G/B/A */
  igtl_float32 position[3]; /* Coordinate of the point */
  igtl_float32 radius; /* Radius of the point. Can be 0. */
  char         owner[IGTL_POINT_LEN_OWNER];/* Device name of the ower image */
} igtl_point_element;

#define igtl_point_get_data_size(n)  ((n) * IGTL_POINT_ELEMENT_SIZE)
#define igtl_point_get_data_n(size)  ((size) / IGTL_POINT_ELEMENT_SIZE)

%inline%{
void igtl_point_convert_byte_order(igtl_point_element* pointlist, int nelem);
igtl_uint64 igtl_point_get_crc(igtl_point_element* pointlist, int nelem);
%}


// igtl_polydata
#define IGTL_POLY_MAX_ATTR_NAME_LEN 255

#define IGTL_POLY_ATTR_TYPE_SCALAR  0x00
#define IGTL_POLY_ATTR_TYPE_VECTOR  0x01
#define IGTL_POLY_ATTR_TYPE_NORMAL  0x02
#define IGTL_POLY_ATTR_TYPE_TENSOR  0x03
#define IGTL_POLY_ATTR_TYPE_RGBA    0x04
#define IGTL_POLY_ATTR_TYPE_TCOORDS 0x05

typedef struct {
  igtl_uint32      npoints;                  /* Number of points */

  igtl_uint32      nvertices;                /* Number of vertices */
  igtl_uint32      size_vertices;            /* Size of vertex data (bytes) */

  igtl_uint32      nlines;                   /* Number of lines */
  igtl_uint32      size_lines;               /* Size of line data (bytes) */

  igtl_uint32      npolygons;                /* Number of polygons */
  igtl_uint32      size_polygons;            /* Size of polygon data (bytes) */

  igtl_uint32      ntriangle_strips;         /* Number of triangle strips */
  igtl_uint32      size_triangle_strips;     /* Size of triangle strips data (bytes) */

  igtl_uint32      nattributes;              /* Number of attributes */
} igtl_polydata_header;

typedef struct {
  igtl_uint8       type;                     
  igtl_uint8       ncomponents;              
  igtl_uint32      n;
} igtl_polydata_attribute_header;

typedef struct {
  igtl_uint8       type;
  igtl_uint8       ncomponents;
  igtl_uint32      n;
  char *           name;
  igtl_float32 *   data;
} igtl_polydata_attribute;

/** POLYDATA info */
typedef struct {
  igtl_polydata_header   header;             /* Header */
  igtl_float32*          points;             /* Points */
  igtl_uint32 *          vertices;           /* Vertices -- array of (N, i1, i2, i3 ...iN) */
  igtl_uint32 *          lines;              /* Lines -- array of (N, i1, i2, i3 ...iN) */
  igtl_uint32 *          polygons;           /* Polygons -- array of (N, i1, i2, i3 ...iN) */
  igtl_uint32 *          triangle_strips;    /* Triangle strips -- array of (N, i1, i2, i3 ...iN) */
  igtl_polydata_attribute * attributes; /* Array of attributes */
} igtl_polydata_info;

%inline%{
int igtl_polydata_alloc_info(igtl_polydata_info * info);
int igtl_polydata_free_info(igtl_polydata_info * info);
int igtl_polydata_unpack(int type, void * byte_array, igtl_polydata_info * info, igtl_uint64 size);
int igtl_polydata_pack(igtl_polydata_info * info, void * byte_array, int type);
igtl_uint64 igtl_polydata_get_size(igtl_polydata_info * info, int type);
igtl_uint64 igtl_polydata_get_crc(igtl_polydata_info * info, int type, void* polydata_message);
%}


// igtl_position
#define  IGTL_POSITION_MESSAGE_DEFAULT_SIZE           28
#define  IGTL_POSITION_MESSAGE_POSITON_ONLY_SIZE      12  /* size w/o quaternion       */
#define  IGTL_POSITION_MESSAGE_WITH_QUATERNION3_SIZE  24  /* size 3-element quaternion */

typedef struct {
  igtl_float32 position[3];    /* (x, y, z) */
  igtl_float32 quaternion[4];  /* (ox, oy, oz, w) */
} igtl_position;

%inline%{
void igtl_position_convert_byte_order(igtl_position* pos);
void igtl_position_convert_byte_order_position_only(igtl_position* pos);
void igtl_position_convert_byte_order_quaternion3(igtl_position* pos);
igtl_uint64 igtl_position_get_crc(igtl_position* pos);
%}


// igtl_qtdata
#define  IGTL_QTDATA_ELEMENT_SIZE           50
#define  IGTL_STT_QTDATA_SIZE               36
#define  IGTL_RTS_QTDATA_SIZE               1

#define  IGTL_QTDATA_LEN_NAME               20  /* Maximum length of tracking instrument name */
#define  IGTL_STT_QTDATA_LEN_COORDNAME      32  /* Maximum length of coordinate system name */

#define  IGTL_QTDATA_TYPE_TRACKER           1  /* Tracker */
#define  IGTL_QTDATA_TYPE_6D                2  /* 6D instrument (regular instrument) */
#define  IGTL_QTDATA_TYPE_3D                3  /* 3D instrument (only tip of the instrument defined) */
#define  IGTL_QTDATA_TYPE_5D                4  

typedef struct {
  char         name[IGTL_QTDATA_LEN_NAME];  /* Name of instrument / tracker */
  igtl_uint8   type;           /* Tracking data type (1-4) */
  igtl_uint8   reserved;       /* Reserved byte */
  igtl_float32 position[3];    /* position (x, y, z) */
  igtl_float32 quaternion[4];  /* orientation as quaternion (qx, qy, qz, w) */
} igtl_qtdata_element;

typedef struct {
  igtl_int32   resolution;     /* Minimum time between two frames. Use 0 for as fast as possible. */
                               /* If e.g. 50 ms is specified, the maximum update rate will be 20 Hz. */
  char         coord_name[IGTL_STT_QTDATA_LEN_COORDNAME]; /* Name of the coordinate system */
} igtl_stt_qtdata;

typedef struct {
  igtl_int8    status;         /* 0: Success 1: Error */
} igtl_rts_qtdata;

#define igtl_qtdata_get_data_size(n)  ((n) * IGTL_QTDATA_ELEMENT_SIZE)
#define igtl_qtdata_get_data_n(size)  ((size) / IGTL_QTDATA_ELEMENT_SIZE)

%inline%{
void igtl_qtdata_convert_byte_order(igtl_qtdata_element* qtdatalist, int nelem);
void igtl_stt_qtdata_convert_byte_order(igtl_stt_qtdata* stt_qtdata);
void igtl_rts_qtdata_convert_byte_order(igtl_rts_qtdata* rts_qtdata);
igtl_uint64 igtl_qtdata_get_crc(igtl_qtdata_element* qtdatalist, int nelem);
igtl_uint64 igtl_stt_qtdata_get_crc(igtl_stt_qtdata* stt_qtdata);
igtl_uint64 igtl_rts_qtdata_get_crc(igtl_rts_qtdata* rts_qtdata);
%}


// igtl_qtrans
#define  IGTL_QTRANS_MESSAGE_DEFAULT_SIZE           28
#define  IGTL_QTRANS_MESSAGE_POSITON_ONLY_SIZE      12  
#define  IGTL_QTRANS_MESSAGE_WITH_QUATERNION3_SIZE  24  

typedef struct {
  igtl_float32 qtrans[3];    /* (x, y, z) */
  igtl_float32 quaternion[4];  /* (ox, oy, oz, w) */
} igtl_qtrans;

%inline%{
void igtl_qtrans_convert_byte_order(igtl_qtrans* pos);
igtl_uint64 igtl_qtrans_get_crc(igtl_qtrans* pos);
%}


// igtl_sensor
#define IGTL_SENSOR_HEADER_SIZE          10
typedef struct {
  igtl_uint8     larray;           /* Length of array (0-255) */
  igtl_uint8     status;           /* (reserved) sensor status */
  igtl_unit      unit;             /* Unit */
} igtl_sensor_header;

%inline%{
igtl_uint32 igtl_sensor_get_data_size(igtl_sensor_header * header);
void igtl_sensor_convert_byte_order(igtl_sensor_header * header, igtl_float64* data);
igtl_uint64 igtl_sensor_get_crc(igtl_sensor_header * header, igtl_float64* data);
%}


// igtl_string
#define IGTL_STRING_HEADER_SIZE          4
typedef struct {
  igtl_uint16    encoding;         /* Character encoding type as MIBenum value (defined by IANA). Default=3. */
                                   /* Please refer http://www.iana.org/assignments/character-sets for detail */
  igtl_uint16    length;           /* Length of string */
} igtl_string_header;

%inline%{
igtl_uint32 igtl_string_get_string_length(igtl_string_header * header);
void igtl_string_convert_byte_order(igtl_string_header * header);
igtl_uint64 igtl_string_get_crc(igtl_string_header * header, void* string);
%}


// igtl_tdata
#define  IGTL_TDATA_ELEMENT_SIZE           70
#define  IGTL_STT_TDATA_SIZE               36
#define  IGTL_RTS_TDATA_SIZE               1

#define  IGTL_TDATA_LEN_NAME               20  /* Maximum length of tracking instrument name */
#define  IGTL_STT_TDATA_LEN_COORDNAME      32  /* Maximum length of coordinate system name */

#define  IGTL_TDATA_TYPE_TRACKER           1  /* Tracker */
#define  IGTL_TDATA_TYPE_6D                2  /* 6D instrument (regular instrument) */
#define  IGTL_TDATA_TYPE_3D                3  /* 3D instrument (only tip of the instrument defined) */
#define  IGTL_TDATA_TYPE_5D                4  

typedef struct {
  char         name[IGTL_TDATA_LEN_NAME];  /* Name of instrument / tracker */
  igtl_uint8   type;           /* Tracking data type (1-4) */
  igtl_uint8   reserved;       /* Reserved byte */
  igtl_float32 transform[12];  /* same as TRANSFORM */
} igtl_tdata_element;

typedef struct {
  igtl_int32   resolution;     /* Minimum time between two frames. Use 0 for as fast as possible. */
                               /* If e.g. 50 ms is specified, the maximum update rate will be 20 Hz. */
  char         coord_name[IGTL_STT_TDATA_LEN_COORDNAME]; /* Name of the coordinate system */
} igtl_stt_tdata;

typedef struct {
  igtl_int8    status;         /* 0: Success 1: Error */
} igtl_rts_tdata;

#define igtl_tdata_get_data_size(n)  ((n) * IGTL_TDATA_ELEMENT_SIZE)
#define igtl_tdata_get_data_n(size)  ((size) / IGTL_TDATA_ELEMENT_SIZE)

%inline%{
void igtl_tdata_convert_byte_order(igtl_tdata_element* tdatalist, int nelem);
void igtl_stt_tdata_convert_byte_order(igtl_stt_tdata* stt_tdata);
void igtl_rts_tdata_convert_byte_order(igtl_rts_tdata* rts_tdata);
igtl_uint64 igtl_tdata_get_crc(igtl_tdata_element* tdatalist, int nelem);
igtl_uint64 igtl_stt_tdata_get_crc(igtl_stt_tdata* stt_tdata);
igtl_uint64 igtl_rts_tdata_get_crc(igtl_rts_tdata* rts_tdata);
%}


// igtl_trajectory
#define IGTL_TRAJECTORY_ELEMENT_SIZE           150
#define IGTL_TRAJECTORY_LEN_NAME                64
#define IGTL_TRAJECTORY_LEN_GROUP_NAME          32
#define IGTL_TRAJECTORY_LEN_OWNER               20

#define IGTL_TRAJECTORY_TYPE_ENTRY_ONLY          1
#define IGTL_TRAJECTORY_TYPE_TARGET_ONLY         2
#define IGTL_TRAJECTORY_TYPE_ENTRY_TARGET        3

typedef struct {
  char         name[IGTL_TRAJECTORY_LEN_NAME];          /* Name or description of the trajectory */
  char         group_name[IGTL_TRAJECTORY_LEN_GROUP_NAME];    /* Can be "Trajectory",  ... */
  igtl_int8    type;              /* Trajectory type (see IGTL_TRAJECTORY_TYPE_* macros) */
  igtl_int8    reserved;
  igtl_uint8   rgba[4];           /* Color in R/G/B/A */
  igtl_float32 entry_pos[3];      /* Coordinate of the entry point */
  igtl_float32 target_pos[3];     /* Coordinate of the target point */
  igtl_float32 radius;            /* Radius of the trajectory. Can be 0. */
  char         owner_name[IGTL_TRAJECTORY_LEN_OWNER];    /* Device name of the ower image */
} igtl_trajectory_element;

#define igtl_trajectory_get_data_size(n)  ((n) * IGTL_TRAJECTORY_ELEMENT_SIZE)
#define igtl_trajectory_get_data_n(size)  ((size) / IGTL_TRAJECTORY_ELEMENT_SIZE)

%inline%{
void igtl_trajectory_convert_byte_order(igtl_trajectory_element* trajectorylist, int nelem);
igtl_uint64 igtl_trajectory_get_crc(igtl_trajectory_element* trajectorylist, int nelem);
%}


// igtl_transform
#define IGTL_TRANSFORM_SIZE   48

%inline%{
void igtl_transform_convert_byte_order(igtl_float32* transform);
igtl_uint64 igtl_transform_get_crc(igtl_float32* transform);
%}

// igtl_types
enum IANA_ENCODING_TYPE
{
  IANA_TYPE_US_ASCII = 3,
  IANA_TYPE_ISO_8859_1 = 4,
  IANA_TYPE_ISO_8859_2 = 5,
  IANA_TYPE_ISO_8859_3 = 6,
  IANA_TYPE_ISO_8859_4 = 7,
  IANA_TYPE_ISO_8859_5 = 8,
  IANA_TYPE_ISO_8859_6 = 9,
  IANA_TYPE_ISO_8859_7 = 10,
  IANA_TYPE_ISO_8859_8 = 11,
  IANA_TYPE_ISO_8859_9 = 12,
  IANA_TYPE_ISO_8859_10 = 13,
  IANA_TYPE_ISO_6937_2_add = 14,
  IANA_TYPE_JIS_X0201 = 15,
  IANA_TYPE_JIS_Encoding = 16,
  IANA_TYPE_Shift_JIS = 17,
  IANA_TYPE_EUC_JP = 18,
  IANA_TYPE_Extended_UNIX_Code_Fixed_Width_for_Japanese = 19,
  IANA_TYPE_BS_4730 = 20,
  IANA_TYPE_SEN_850200_C = 21,
  IANA_TYPE_IT = 22,
  IANA_TYPE_ES = 23,
  IANA_TYPE_DIN_66003 = 24,
  IANA_TYPE_NS_4551_1 = 25,
  IANA_TYPE_NF_Z_62_010 = 26,
  IANA_TYPE_ISO_10646_UTF_1 = 27,
  IANA_TYPE_ISO_646_basic_1983 = 28,
  IANA_TYPE_INVARIANT = 29,
  IANA_TYPE_ISO_646_irv_1983 = 30,
  IANA_TYPE_NATS_SEFI = 31,
  IANA_TYPE_NATS_SEFI_ADD = 32,
  IANA_TYPE_NATS_DANO = 33,
  IANA_TYPE_NATS_DANO_ADD = 34,
  IANA_TYPE_SEN_850200_B = 35,
  IANA_TYPE_KS_C_5601_1987 = 36,
  IANA_TYPE_ISO_2022_KR = 37,
  IANA_TYPE_EUC_KR = 38,
  IANA_TYPE_ISO_2022_JP = 39,
  IANA_TYPE_ISO_2022_JP_2 = 40,
  IANA_TYPE_JIS_C6220_1969_jp = 41,
  IANA_TYPE_JIS_C6220_1969_ro = 42,
  IANA_TYPE_PT = 43,
  IANA_TYPE_greek7_old = 44,
  IANA_TYPE_latin_greek = 45,
  IANA_TYPE_NF_Z_62_010_1973 = 46,
  IANA_TYPE_Latin_greek_1 = 47,
  IANA_TYPE_ISO_5427 = 48,
  IANA_TYPE_JIS_C6226_1978 = 49,
  IANA_TYPE_BS_viewdata = 50,
  IANA_TYPE_INIS = 51,
  IANA_TYPE_INIS_8 = 52,
  IANA_TYPE_INIS_cyrillic = 53,
  IANA_TYPE_ISO_5427_1981 = 54,
  IANA_TYPE_ISO_5428_1980 = 55,
  IANA_TYPE_GB_1988_80 = 56,
  IANA_TYPE_GB_2312_80 = 57,
  IANA_TYPE_NS_4551_2 = 58,
  IANA_TYPE_videotex_suppl = 59,
  IANA_TYPE_PT2 = 60,
  IANA_TYPE_ES2 = 61,
  IANA_TYPE_MSZ_7795_3 = 62,
  IANA_TYPE_JIS_C6226_1983 = 63,
  IANA_TYPE_greek7 = 64,
  IANA_TYPE_ASMO_449 = 65,
  IANA_TYPE_iso_ir_90 = 66,
  IANA_TYPE_JIS_C6229_1984_a = 67,
  IANA_TYPE_JIS_C6229_1984_b = 68,
  IANA_TYPE_JIS_C6229_1984_b_add = 69,
  IANA_TYPE_JIS_C6229_1984_hand = 70,
  IANA_TYPE_JIS_C6229_1984_hand_add = 71,
  IANA_TYPE_JIS_C6229_1984_kana = 72,
  IANA_TYPE_ISO_2033_1983 = 73,
  IANA_TYPE_ANSI_X3_110_1983 = 74,
  IANA_TYPE_T_61_7bit = 75,
  IANA_TYPE_T_61_8bit = 76,
  IANA_TYPE_ECMA_cyrillic = 77,
  IANA_TYPE_CSA_Z243_4_1985_1 = 78,
  IANA_TYPE_CSA_Z243_4_1985_2 = 79,
  IANA_TYPE_CSA_Z243_4_1985_gr = 80,
  IANA_TYPE_ISO_8859_6_E = 81,
  IANA_TYPE_ISO_8859_6_I = 82,
  IANA_TYPE_T_101_G2 = 83,
  IANA_TYPE_ISO_8859_8_E = 84,
  IANA_TYPE_ISO_8859_8_I = 85,
  IANA_TYPE_CSN_369103 = 86,
  IANA_TYPE_JUS_I_B1_002 = 87,
  IANA_TYPE_IEC_P27_1 = 88,
  IANA_TYPE_JUS_I_B1_003_serb = 89,
  IANA_TYPE_JUS_I_B1_003_mac = 90,
  IANA_TYPE_greek_ccitt = 91,
  IANA_TYPE_NC_NC00_10_81 = 92,
  IANA_TYPE_ISO_6937_2_25 = 93,
  IANA_TYPE_GOST_19768_74 = 94,
  IANA_TYPE_ISO_8859_supp = 95,
  IANA_TYPE_ISO_10367_box = 96,
  IANA_TYPE_latin_lap = 97,
  IANA_TYPE_JIS_X0212_1990 = 98,
  IANA_TYPE_DS_2089 = 99,
  IANA_TYPE_us_dk = 100,
  IANA_TYPE_dk_us = 101,
  IANA_TYPE_KSC5636 = 102,
  IANA_TYPE_UNICODE_1_1_UTF_7 = 103,
  IANA_TYPE_ISO_2022_CN = 104,
  IANA_TYPE_ISO_2022_CN_EXT = 105,
  IANA_TYPE_UTF_8 = 106,
  IANA_TYPE_ISO_8859_13 = 109,
  IANA_TYPE_ISO_8859_14 = 110,
  IANA_TYPE_ISO_8859_15 = 111,
  IANA_TYPE_ISO_8859_16 = 112,
  IANA_TYPE_GBK = 113,
  IANA_TYPE_GB18030 = 114,
  IANA_TYPE_OSD_EBCDIC_DF04_15 = 115,
  IANA_TYPE_OSD_EBCDIC_DF03_IRV = 116,
  IANA_TYPE_OSD_EBCDIC_DF04_1 = 117,
  IANA_TYPE_ISO_11548_1 = 118,
  IANA_TYPE_KZ_1048 = 119,
  IANA_TYPE_ISO_10646_UCS_2 = 1000,
  IANA_TYPE_ISO_10646_UCS_4 = 1001,
  IANA_TYPE_ISO_10646_UCS_Basic = 1002,
  IANA_TYPE_ISO_10646_Unicode_Latin1 = 1003,
  IANA_TYPE_ISO_10646_J_1 = 1004,
  IANA_TYPE_ISO_Unicode_IBM_1261 = 1005,
  IANA_TYPE_ISO_Unicode_IBM_1268 = 1006,
  IANA_TYPE_ISO_Unicode_IBM_1276 = 1007,
  IANA_TYPE_ISO_Unicode_IBM_1264 = 1008,
  IANA_TYPE_ISO_Unicode_IBM_1265 = 1009,
  IANA_TYPE_UNICODE_1_1 = 1010,
  IANA_TYPE_SCSU = 1011,
  IANA_TYPE_UTF_7 = 1012,
  IANA_TYPE_UTF_16BE = 1013,
  IANA_TYPE_UTF_16LE = 1014,
  IANA_TYPE_UTF_16 = 1015,
  IANA_TYPE_CESU_8 = 1016,
  IANA_TYPE_UTF_32 = 1017,
  IANA_TYPE_UTF_32BE = 1018,
  IANA_TYPE_UTF_32LE = 1019,
  IANA_TYPE_BOCU_1 = 1020,
  IANA_TYPE_ISO_8859_1_Windows_3_0_Latin_1 = 2000,
  IANA_TYPE_ISO_8859_1_Windows_3_1_Latin_1 = 2001,
  IANA_TYPE_ISO_8859_2_Windows_Latin_2 = 2002,
  IANA_TYPE_ISO_8859_9_Windows_Latin_5 = 2003,
  IANA_TYPE_hp_roman8 = 2004,
  IANA_TYPE_Adobe_Standard_Encoding = 2005,
  IANA_TYPE_Ventura_US = 2006,
  IANA_TYPE_Ventura_International = 2007,
  IANA_TYPE_DEC_MCS = 2008,
  IANA_TYPE_IBM850 = 2009,
  IANA_TYPE_PC8_Danish_Norwegian = 2012,
  IANA_TYPE_IBM862 = 2013,
  IANA_TYPE_PC8_Turkish = 2014,
  IANA_TYPE_IBM_Symbols = 2015,
  IANA_TYPE_IBM_Thai = 2016,
  IANA_TYPE_HP_Legal = 2017,
  IANA_TYPE_HP_Pi_font = 2018,
  IANA_TYPE_HP_Math8 = 2019,
  IANA_TYPE_Adobe_Symbol_Encoding = 2020,
  IANA_TYPE_HP_DeskTop = 2021,
  IANA_TYPE_Ventura_Math = 2022,
  IANA_TYPE_Microsoft_Publishing = 2023,
  IANA_TYPE_Windows_31J = 2024,
  IANA_TYPE_GB2312 = 2025,
  IANA_TYPE_Big5 = 2026,
  IANA_TYPE_macintosh = 2027,
  IANA_TYPE_IBM037 = 2028,
  IANA_TYPE_IBM038 = 2029,
  IANA_TYPE_IBM273 = 2030,
  IANA_TYPE_IBM274 = 2031,
  IANA_TYPE_IBM275 = 2032,
  IANA_TYPE_IBM277 = 2033,
  IANA_TYPE_IBM278 = 2034,
  IANA_TYPE_IBM280 = 2035,
  IANA_TYPE_IBM281 = 2036,
  IANA_TYPE_IBM284 = 2037,
  IANA_TYPE_IBM285 = 2038,
  IANA_TYPE_IBM290 = 2039,
  IANA_TYPE_IBM297 = 2040,
  IANA_TYPE_IBM420 = 2041,
  IANA_TYPE_IBM423 = 2042,
  IANA_TYPE_IBM424 = 2043,
  IANA_TYPE_IBM437 = 2011,
  IANA_TYPE_IBM500 = 2044,
  IANA_TYPE_IBM851 = 2045,
  IANA_TYPE_IBM852 = 2010,
  IANA_TYPE_IBM855 = 2046,
  IANA_TYPE_IBM857 = 2047,
  IANA_TYPE_IBM860 = 2048,
  IANA_TYPE_IBM861 = 2049,
  IANA_TYPE_IBM863 = 2050,
  IANA_TYPE_IBM864 = 2051,
  IANA_TYPE_IBM865 = 2052,
  IANA_TYPE_IBM868 = 2053,
  IANA_TYPE_IBM869 = 2054,
  IANA_TYPE_IBM870 = 2055,
  IANA_TYPE_IBM871 = 2056,
  IANA_TYPE_IBM880 = 2057,
  IANA_TYPE_IBM891 = 2058,
  IANA_TYPE_IBM903 = 2059,
  IANA_TYPE_IBM904 = 2060,
  IANA_TYPE_IBM905 = 2061,
  IANA_TYPE_IBM918 = 2062,
  IANA_TYPE_IBM1026 = 2063,
  IANA_TYPE_EBCDIC_AT_DE = 2064,
  IANA_TYPE_EBCDIC_AT_DE_A = 2065,
  IANA_TYPE_EBCDIC_CA_FR = 2066,
  IANA_TYPE_EBCDIC_DK_NO = 2067,
  IANA_TYPE_EBCDIC_DK_NO_A = 2068,
  IANA_TYPE_EBCDIC_FI_SE = 2069,
  IANA_TYPE_EBCDIC_FI_SE_A = 2070,
  IANA_TYPE_EBCDIC_FR = 2071,
  IANA_TYPE_EBCDIC_IT = 2072,
  IANA_TYPE_EBCDIC_PT = 2073,
  IANA_TYPE_EBCDIC_ES = 2074,
  IANA_TYPE_EBCDIC_ES_A = 2075,
  IANA_TYPE_EBCDIC_ES_S = 2076,
  IANA_TYPE_EBCDIC_UK = 2077,
  IANA_TYPE_EBCDIC_US = 2078,
  IANA_TYPE_UNKNOWN_8BIT = 2079,
  IANA_TYPE_MNEMONIC = 2080,
  IANA_TYPE_MNEM = 2081,
  IANA_TYPE_VISCII = 2082,
  IANA_TYPE_VIQR = 2083,
  IANA_TYPE_KOI8_R = 2084,
  IANA_TYPE_HZ_GB_2312 = 2085,
  IANA_TYPE_IBM866 = 2086,
  IANA_TYPE_IBM775 = 2087,
  IANA_TYPE_KOI8_U = 2088,
  IANA_TYPE_IBM00858 = 2089,
  IANA_TYPE_IBM00924 = 2090,
  IANA_TYPE_IBM01140 = 2091,
  IANA_TYPE_IBM01141 = 2092,
  IANA_TYPE_IBM01142 = 2093,
  IANA_TYPE_IBM01143 = 2094,
  IANA_TYPE_IBM01144 = 2095,
  IANA_TYPE_IBM01145 = 2096,
  IANA_TYPE_IBM01146 = 2097,
  IANA_TYPE_IBM01147 = 2098,
  IANA_TYPE_IBM01148 = 2099,
  IANA_TYPE_IBM01149 = 2100,
  IANA_TYPE_Big5_HKSCS = 2101,
  IANA_TYPE_IBM1047 = 2102,
  IANA_TYPE_PTCP154 = 2103,
  IANA_TYPE_Amiga_1251 = 2104,
  IANA_TYPE_KOI7_switched = 2105,
  IANA_TYPE_BRF = 2106,
  IANA_TYPE_TSCII = 2107,
  IANA_TYPE_CP51932 = 2108,
  IANA_TYPE_windows_874 = 2109,
  IANA_TYPE_windows_1250 = 2250,
  IANA_TYPE_windows_1251 = 2251,
  IANA_TYPE_windows_1252 = 2252,
  IANA_TYPE_windows_1253 = 2253,
  IANA_TYPE_windows_1254 = 2254,
  IANA_TYPE_windows_1255 = 2255,
  IANA_TYPE_windows_1256 = 2256,
  IANA_TYPE_windows_1257 = 2257,
  IANA_TYPE_windows_1258 = 2258,
  IANA_TYPE_TIS_620 = 2259,
  IANA_TYPE_CP50220 = 2260
};

typedef unsigned char igtl_uint8;
typedef signed char   igtl_int8;
typedef unsigned short igtl_uint16;
typedef signed short   igtl_int16;
typedef unsigned int   igtl_uint32;
typedef signed int     igtl_int32;
typedef unsigned long long igtl_uint64;
typedef signed long long   igtl_int64;
typedef float              igtl_float32;
typedef double             igtl_float64;
typedef double igtl_complex[2];


// igtl_unit
#define IGTL_UNIT_PREFIX_NONE   0x0 /* None */
#define IGTL_UNIT_PREFIX_DEKA   0x1 /* deka (deca) (1e1) */
#define IGTL_UNIT_PREFIX_HECTO  0x2 /* hecto (1e2) */
#define IGTL_UNIT_PREFIX_KILO   0x3 /* kilo (1e3) */
#define IGTL_UNIT_PREFIX_MEGA   0x4 /* mega (1e6) */
#define IGTL_UNIT_PREFIX_GIGA   0x5 /* giga (1e9) */
#define IGTL_UNIT_PREFIX_TERA   0x6 /* tera (1e12) */
#define IGTL_UNIT_PREFIX_PETA   0x7 /* peta (1e15) */
#define IGTL_UNIT_PREFIX_DECI   0x9 /* deci (1e-1) */
#define IGTL_UNIT_PREFIX_CENTI  0xA /* centi (1e-2) */
#define IGTL_UNIT_PREFIX_MILLI  0xB /* milli (1e-3) */
#define IGTL_UNIT_PREFIX_MICRO  0xC /* micro (1e-6) */
#define IGTL_UNIT_PREFIX_NANO   0xD /* nano (1e-9) */
#define IGTL_UNIT_PREFIX_PICO   0xE /* pico (1e-12) */
#define IGTL_UNIT_PREFIX_FEMTO  0xF /* femto (1e-15) */

/* SI Base Units */
#define IGTL_UNIT_SI_BASE_NONE    0x00
#define IGTL_UNIT_SI_BASE_METER   0x01 /* meter */
#define IGTL_UNIT_SI_BASE_GRAM    0x02 /* gram */
#define IGTL_UNIT_SI_BASE_SECOND  0x03 /* second */
#define IGTL_UNIT_SI_BASE_AMPERE  0x04 /* ampere */
#define IGTL_UNIT_SI_BASE_KELVIN  0x05 /* kelvin */
#define IGTL_UNIT_SI_BASE_MOLE    0x06 /* mole */
#define IGTL_UNIT_SI_BASE_CANDELA 0x07 /* candela */

/* SI Derived Units */
#define IGTL_UNIT_SI_DERIVED_RADIAN    0x08  /* radian     meter/meter */
#define IGTL_UNIT_SI_DERIVED_STERADIAN 0x09  /* steradian  meter^2/meter^2 */
#define IGTL_UNIT_SI_DERIVED_HERTZ     0x0A  /* hertz      /second */
#define IGTL_UNIT_SI_DERIVED_NEWTON    0x0B  /* newton     meter-kilogram/second^2 */
#define IGTL_UNIT_SI_DERIVED_PASCAL    0x0C  /* pascal     kilogram/meter-second^2 */
#define IGTL_UNIT_SI_DERIVED_JOULE     0x0D  /* joule      meter^2-kilogram/second^2 */
#define IGTL_UNIT_SI_DERIVED_WATT      0x0E  /* watt       meter^2-kilogram/second^3 */
#define IGTL_UNIT_SI_DERIVED_COULOMB   0x0F  /* coulomb    second-ampere */
#define IGTL_UNIT_SI_DERIVED_VOLT      0x10  /* volt       meter^2-kilogram/second^3-ampere */
#define IGTL_UNIT_SI_DERIVED_FARAD     0x11  /* farad      second^4-ampere^2/meter^2-kilogram */
#define IGTL_UNIT_SI_DERIVED_OHM       0x12  /* ohm        meter^2-kilogram/second^3-ampere^2 */
#define IGTL_UNIT_SI_DERIVED_SIEMENS   0x13  /* siemens    second^3-ampere^2/meter^2-kilogram */
#define IGTL_UNIT_SI_DERIVED_WEBER     0x14  /* weber      meter^2-kilogram/second^2-ampere */
#define IGTL_UNIT_SI_DERIVED_TESLA     0x15  /* tesla      kilogram/second^2-ampere */
#define IGTL_UNIT_SI_DERIVED_HENRY     0x16  /* henry      meter^2-kilogram/second^2-ampere^2 */
#define IGTL_UNIT_SI_DERIVED_LUMEN     0x17  /* lumen      candela-steradian */
#define IGTL_UNIT_SI_DERIVED_LUX       0x18  /* lux        candela-steradian/meter^2 */
#define IGTL_UNIT_SI_DERIVED_BECQUEREL 0x19  /* becquerel  /second */
#define IGTL_UNIT_SI_DERIVED_GRAY      0x1A  /* gray       meter^2/second^2 */
#define IGTL_UNIT_SI_DERIVED_SIEVERT   0x1B  /* sievert    meter^2/second^2 */

typedef igtl_uint64 igtl_unit;

typedef struct {
  igtl_uint8     prefix;            /* Prefix */
  igtl_uint8     unit[6];           /* Either SI-Base or SI-Derived */
  igtl_int8      exp[6];            /* Must be within [-7, 7] */
} igtl_unit_data;

%inline%{
void igtl_unit_init(igtl_unit_data* data);
igtl_unit igtl_unit_pack(igtl_unit_data* data);
int igtl_unit_unpack(igtl_unit pack, igtl_unit_data* data);
%}


// igtl_typeconfig
#define CMAKE_SIZEOF_CHAR
#ifdef CMAKE_SIZEOF_CHAR
  #define IGTL_SIZEOF_CHAR    1
#endif

#define CMAKE_SIZEOF_INT
#ifdef CMAKE_SIZEOF_INT
  #define IGTL_SIZEOF_INT     4
#endif

#define CMAKE_SIZEOF_SHORT
#ifdef CMAKE_SIZEOF_SHORT
  #define IGTL_SIZEOF_SHORT   2
#endif

#define CMAKE_SIZEOF_LONG
#ifdef CMAKE_SIZEOF_LONG
  #define IGTL_SIZEOF_LONG    4
#endif

#define CMAKE_SIZEOF_FLOAT
#ifdef CMAKE_SIZEOF_FLOAT
  #define IGTL_SIZEOF_FLOAT   4
#endif

#define CMAKE_SIZEOF_DOUBLE
#ifdef CMAKE_SIZEOF_DOUBLE
  #define IGTL_SIZEOF_DOUBLE  8
#endif

#define CMAKE_SIZEOF_LONG_LONG
#define CMAKE_SIZEOF___INT64
#define CMAKE_SIZEOF_INT64_T
#ifdef CMAKE_SIZEOF_LONG_LONG
  #define IGTL_TYPE_USE_LONG_LONG 1
  #define IGTL_SIZEOF_LONG_LONG   8
#elif defined(CMAKE_SIZEOF___INT64)
  #define IGTL_TYPE_USE___INT64   1
  #define IGTL_SIZEOF___INT64     8
#elif defined(CMAKE_SIZEOF_INT64_T)
  #define IGTL_TYPE_USE_INT64_T   1
  #define IGTL_SIZEOF_INT64_T     8
#endif

#define CMAKE_SIZEOF_VOID_P

#define OpenIGTLink_PLATFORM_WIN32
#ifdef OpenIGTLink_PLATFORM_WIN32
  #ifndef _WIN32
    #define _WIN32
  #endif
  #ifndef WIN32
    #define WIN32
  #endif
  #define IGTLCommon_EXPORTS
#endif
