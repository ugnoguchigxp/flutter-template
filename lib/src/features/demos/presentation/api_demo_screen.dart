import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../core/networking/api_wrapper.dart';

class ApiDemoScreen extends HookConsumerWidget {
  const ApiDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final apiWrapper = ref.watch(apiWrapperProvider);

    final form = useMemoized(
      () => FormGroup({
        'method': FormControl<String>(
          value: 'GET',
          validators: [Validators.required],
        ),
        'endpoint': FormControl<String>(
          value: '/posts/1',
          validators: [Validators.required],
        ),
        'body': FormControl<String>(value: ''),
        'errorScenario': FormControl<String>(value: 'none'),
      }),
      const [],
    );

    final responseState = useState<String?>(null);
    final isLoading = useState(false);

    useEffect(() => form.dispose, [form]);

    Future<void> executeRequest() async {
      if (!form.valid) return;

      isLoading.value = true;
      responseState.value = null;

      final method = form.control('method').value as String;
      final endpoint = form.control('endpoint').value as String;
      final body = form.control('body').value as String?;
      final errorScenario = form.control('errorScenario').value as String;

      // Add error_scenario query parameter if not 'none'
      final endpointWithParams = errorScenario != 'none'
          ? endpoint.contains('?')
                ? '$endpoint&error_scenario=$errorScenario'
                : '$endpoint?error_scenario=$errorScenario'
          : endpoint;

      ApiResult<Map<String, dynamic>> result;

      switch (method) {
        case 'GET':
          result = await apiWrapper.get<Map<String, dynamic>>(
            endpointWithParams,
            parser: (data) => data as Map<String, dynamic>,
            logData: {'endpoint': endpointWithParams},
          );
        case 'POST':
          final bodyData = body != null && body.isNotEmpty
              ? jsonDecode(body) as Map<String, dynamic>
              : <String, dynamic>{};
          result = await apiWrapper.post<Map<String, dynamic>>(
            endpointWithParams,
            data: bodyData,
            parser: (data) => data as Map<String, dynamic>,
            logData: {'endpoint': endpointWithParams},
          );
        case 'PUT':
          final bodyData = body != null && body.isNotEmpty
              ? jsonDecode(body) as Map<String, dynamic>
              : <String, dynamic>{};
          result = await apiWrapper.put<Map<String, dynamic>>(
            endpointWithParams,
            data: bodyData,
            parser: (data) => data as Map<String, dynamic>,
            logData: {'endpoint': endpointWithParams},
          );
        case 'DELETE':
          result = await apiWrapper.delete<Map<String, dynamic>>(
            endpointWithParams,
            parser: (data) => data as Map<String, dynamic>,
            logData: {'endpoint': endpointWithParams},
          );
        default:
          isLoading.value = false;
          return;
      }

      result.when(
        success: (data) {
          final formatted = const JsonEncoder.withIndent('  ').convert(data);
          responseState.value = 'Success:\n\n$formatted';
        },
        failure: (error) {
          responseState.value =
              'Error [${error.code}]:\n\n'
              'Message: ${error.message}\n'
              'User Message: ${error.userMessage}\n\n'
              'Details: ${error.details}';
        },
      );

      isLoading.value = false;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: ReactiveForm(
        formGroup: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('api_demo.title'),
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('api_demo.subtitle'),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('api_demo.request_settings'),
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ReactiveDropdownField<String>(
                      formControlName: 'method',
                      decoration: InputDecoration(
                        labelText: context.tr('api_demo.method'),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'GET',
                          child: Text(context.tr('api_demo.methods.get')),
                        ),
                        DropdownMenuItem(
                          value: 'POST',
                          child: Text(context.tr('api_demo.methods.post')),
                        ),
                        DropdownMenuItem(
                          value: 'PUT',
                          child: Text(context.tr('api_demo.methods.put')),
                        ),
                        DropdownMenuItem(
                          value: 'DELETE',
                          child: Text(context.tr('api_demo.methods.delete')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ReactiveTextField<String>(
                      formControlName: 'endpoint',
                      decoration: InputDecoration(
                        labelText: context.tr('api_demo.endpoint'),
                        hintText: '/posts/1',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ReactiveTextField<String>(
                      formControlName: 'body',
                      decoration: InputDecoration(
                        labelText: context.tr('api_demo.request_body'),
                        hintText: context.tr('api_demo.request_body_hint'),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    ReactiveDropdownField<String>(
                      formControlName: 'errorScenario',
                      decoration: const InputDecoration(
                        labelText: 'Error Scenario',
                        helperText:
                            'Select error scenario to test error handling',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'none',
                          child: Text('None (Normal Response)'),
                        ),
                        DropdownMenuItem(
                          value: '500',
                          child: Text('500 Internal Server Error'),
                        ),
                        DropdownMenuItem(
                          value: '503',
                          child: Text('503 Service Unavailable'),
                        ),
                        DropdownMenuItem(
                          value: '404',
                          child: Text('404 Not Found'),
                        ),
                        DropdownMenuItem(
                          value: 'validation',
                          child: Text('422 Validation Error'),
                        ),
                        DropdownMenuItem(
                          value: 'timeout',
                          child: Text('Timeout (30s delay)'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ReactiveFormConsumer(
                      builder: (context, formGroup, child) => FilledButton.icon(
                        icon: isLoading.value
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send),
                        label: Text(context.tr('api_demo.execute_request')),
                        onPressed: isLoading.value || !formGroup.valid
                            ? null
                            : executeRequest,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (responseState.value != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            context.tr('api_demo.response'),
                            style: theme.textTheme.titleLarge,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            tooltip: context.tr('api_demo.clear'),
                            onPressed: () => responseState.value = null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          responseState.value!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('api_demo.test_endpoints'),
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.tr('api_demo.test_endpoints_subtitle'),
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    _EndpointExample(
                      method: 'GET',
                      endpoint: '/posts/1',
                      description: context.tr('api_demo.get_post'),
                      onTap: () {
                        form.control('method').value = 'GET';
                        form.control('endpoint').value = '/posts/1';
                      },
                    ),
                    _EndpointExample(
                      method: 'GET',
                      endpoint: '/posts',
                      description: context.tr('api_demo.get_users'),
                      onTap: () {
                        form.control('method').value = 'GET';
                        form.control('endpoint').value = '/posts';
                      },
                    ),
                    _EndpointExample(
                      method: 'POST',
                      endpoint: '/posts',
                      description: context.tr('api_demo.create_post'),
                      onTap: () {
                        form.control('method').value = 'POST';
                        form.control('endpoint').value = '/posts';
                        form.control('body').value =
                            '{"title": "New Post", "body": "Post content", "author": "Test User"}';
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EndpointExample extends StatelessWidget {
  const _EndpointExample({
    required this.method,
    required this.endpoint,
    required this.description,
    required this.onTap,
  });

  final String method;
  final String endpoint;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getMethodColor(method, theme),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                method,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              endpoint,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(width: 12),
            Text(description, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Color _getMethodColor(String method, ThemeData theme) {
    switch (method) {
      case 'GET':
        return Colors.blue;
      case 'POST':
        return Colors.green;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }
}
