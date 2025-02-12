import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_project/network/exception.dart';

@immutable
class BaseState extends Equatable {
  const BaseState({
    this.status = StateStatus.initial,
    this.httpException,
  });

  final StateStatus status;
  final HttpException? httpException;

  @override
  List<Object?> get props => [
    status,
    httpException,
  ];

  @override
  String toString() {
    return '"state": {"status": "$status", "http_exception": $httpException}';
  }
}

enum StateStatus { initial, loading, loaded, error }

extension BaseStateExtension on BaseState {
  bool get isLoaded => status == StateStatus.loaded;
  bool get isError => status == StateStatus.error;
  bool get isLoading => status == StateStatus.loading;
  bool get isInitial => status == StateStatus.initial;
}
