class AiAnalysis {
  final int? id;
  final String? summary;
  final String? status;
  final DateTime? createdAt;

  AiAnalysis({
    this.id,
    this.summary,
    this.status,
    this.createdAt,
  });

  factory AiAnalysis.fromJson(Map<String, dynamic> json) {
    return AiAnalysis(
      id: json['id'] as int?,
      summary: json['summary']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) 
          : null,
    );
  }
}