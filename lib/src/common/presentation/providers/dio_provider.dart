import 'package:dio/dio.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider cho Dio instance, một thư viện để thực hiện các yêu cầu HTTP
final dioProvider = Provider<Dio>((ref) => AppDio.getInstance());
