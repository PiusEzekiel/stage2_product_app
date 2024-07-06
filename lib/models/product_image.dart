// class ProductImage {
//   final String modelName;
//   final String modelId;
//   final String organizationId;
//   final String filename;
//   final String url;
//   final bool isFeatured;
//   final bool saveAsJpg;
//   final bool isPublic;
//   final bool fileRename;
//   final int position;

//   ProductImage({
//     required this.modelName,
//     required this.modelId,
//     required this.organizationId,
//     required this.filename,
//     required this.url,
//     required this.isFeatured,
//     required this.saveAsJpg,
//     required this.isPublic,
//     required this.fileRename,
//     required this.position,
//   });

//   factory ProductImage.fromJson(Map<String, dynamic> json) {
//     return ProductImage(
//       modelName: json['model_name'],
//       modelId: json['model_id'],
//       organizationId: json['organization_id'],
//       filename: json['filename'],
//       url: json['url'],
//       isFeatured: json['is_featured'],
//       saveAsJpg: json['save_as_jpg'],
//       isPublic: json['is_public'],
//       fileRename: json['file_rename'],
//       position: json['position'],
//     );
//   }
// }
