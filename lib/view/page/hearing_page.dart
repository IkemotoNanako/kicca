import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kicca/domain/model/hearing_data_model.dart';
import 'package:kicca/services/hearing_service.dart';

/// ヒヤリング画面
class HearingPage extends StatefulWidget {
  const HearingPage({super.key});

  @override
  State<HearingPage> createState() => _HearingPageState();
}

class _HearingPageState extends State<HearingPage> {
  /// 生活での困りごと
  final _lifeDifficultiesController = TextEditingController();

  /// 仕事での困りごと
  final _workDifficultiesController = TextEditingController();

  /// 得意なこと
  final _strengthsController = TextEditingController();

  /// フォームのキー
  final _formKey = GlobalKey<FormState>();

  /// ヒヤリングサービス
  late final HearingService _service;

  @override
  void initState() {
    super.initState();
    _initService();
    _loadData();
  }

  /// サービスを初期化する
  Future<void> _initService() async {
    final prefs = await SharedPreferences.getInstance();
    _service = HearingService(prefs);
  }

  /// データを読み込む
  Future<void> _loadData() async {
    final data = _service.getHearingData();
    if (data != null) {
      setState(() {
        _lifeDifficultiesController.text = data.lifeDifficulties;
        _workDifficultiesController.text = data.workDifficulties;
        _strengthsController.text = data.strengths;
      });
    }
  }

  @override
  void dispose() {
    _lifeDifficultiesController.dispose();
    _workDifficultiesController.dispose();
    _strengthsController.dispose();
    super.dispose();
  }

  /// データを保存する
  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      final data = HearingDataModel(
        lifeDifficulties: _lifeDifficultiesController.text,
        workDifficulties: _workDifficultiesController.text,
        strengths: _strengthsController.text,
      );

      await _service.saveHearingData(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('データを保存しました')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ヒヤリング'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              '生活での困りごと',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _lifeDifficultiesController,
              decoration: const InputDecoration(
                hintText: '生活で困っていることを入力してください',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '生活での困りごとを入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              '仕事での困りごと',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _workDifficultiesController,
              decoration: const InputDecoration(
                hintText: '仕事で困っていることを入力してください',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '仕事での困りごとを入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              '得意なこと',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _strengthsController,
              decoration: const InputDecoration(
                hintText: '得意なことを入力してください',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '得意なことを入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
