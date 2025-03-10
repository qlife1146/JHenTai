import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhentai/src/extension/widget_extension.dart';

import '../../../consts/locale_consts.dart';
import '../../../l18n/locale_text.dart';
import '../../../model/jh_layout.dart';
import '../../../service/tag_translation_service.dart';
import '../../../setting/preference_setting.dart';
import '../../../setting/style_setting.dart';
import '../../../utils/locale_util.dart';
import '../../../widget/loading_state_indicator.dart';

class SettingPreferencePage extends StatelessWidget {
  final TagTranslationService tagTranslationService = Get.find();

  SettingPreferencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('preferenceSetting'.tr)),
      body: Obx(
        () => SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(top: 16),
            children: [
              _buildLanguage(),
              _buildTagTranslate(),
              if (StyleSetting.isInV2Layout) _buildShowBottomNavigation(),
              _buildEnableSwipeBackGesture(),
              if (StyleSetting.isInV2Layout) _buildEnableLeftMenuDrawerGesture(),
              if (StyleSetting.isInV2Layout) _buildQuickSearch(),
              if (StyleSetting.isInV2Layout || StyleSetting.actualLayout == LayoutMode.desktop) _buildAlwaysShowScroll2TopButton(),
              if (PreferenceSetting.enableTagZHTranslation.isTrue) _buildShowR18GImageDirectly().fadeIn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguage() {
    return ListTile(
      title: Text('language'.tr),
      trailing: DropdownButton<Locale>(
        value: PreferenceSetting.locale.value,
        elevation: 4,
        alignment: AlignmentDirectional.centerEnd,
        onChanged: (Locale? newValue) => PreferenceSetting.saveLanguage(newValue!),
        items: LocaleText()
            .keys
            .keys
            .map((localeCode) => DropdownMenuItem(
                  child: Text(LocaleConsts.localeCode2Description[localeCode]!),
                  value: localeCode2Locale(localeCode),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTagTranslate() {
    return ListTile(
      title: Text('enableTagZHTranslation'.tr),
      subtitle: tagTranslationService.loadingState.value == LoadingState.success
          ? Text('${'version'.tr}: ${tagTranslationService.timeStamp.value!}', style: const TextStyle(fontSize: 12))
          : tagTranslationService.loadingState.value == LoadingState.loading
              ? Text(
                  '${'downloadTagTranslationHint'.tr}${tagTranslationService.downloadProgress.value}',
                  style: const TextStyle(fontSize: 12),
                )
              : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingStateIndicator(
            useCupertinoIndicator: true,
            loadingState: tagTranslationService.loadingState.value,
            indicatorRadius: 10,
            width: 40,
            idleWidget: IconButton(onPressed: tagTranslationService.refresh, icon: const Icon(Icons.refresh)),
            errorWidgetSameWithIdle: true,
            successWidgetSameWithIdle: true,
          ),
          Switch(
            value: PreferenceSetting.enableTagZHTranslation.value,
            onChanged: (value) {
              PreferenceSetting.saveEnableTagZHTranslation(value);
              if (value == true && tagTranslationService.loadingState.value != LoadingState.success) {
                tagTranslationService.refresh();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildShowBottomNavigation() {
    return SwitchListTile(
      title: Text('hideBottomBar'.tr),
      value: PreferenceSetting.hideBottomBar.value,
      onChanged: PreferenceSetting.saveHideBottomBar,
    );
  }

  Widget _buildEnableSwipeBackGesture() {
    return SwitchListTile(
      title: Text('enableSwipeBackGesture'.tr),
      subtitle: Text('needRestart'.tr),
      value: PreferenceSetting.enableSwipeBackGesture.value,
      onChanged: PreferenceSetting.saveEnableSwipeBackGesture,
    );
  }

  Widget _buildEnableLeftMenuDrawerGesture() {
    return SwitchListTile(
      title: Text('enableLeftMenuDrawerGesture'.tr),
      value: PreferenceSetting.enableLeftMenuDrawerGesture.value,
      onChanged: PreferenceSetting.saveEnableLeftMenuDrawerGesture,
    );
  }

  Widget _buildQuickSearch() {
    return ListTile(
      title: Text('enableQuickSearchDrawerGesture'.tr),
      trailing: Switch(
        value: PreferenceSetting.enableQuickSearchDrawerGesture.value,
        onChanged: PreferenceSetting.saveEnableQuickSearchDrawerGesture,
      ),
    );
  }

  Widget _buildAlwaysShowScroll2TopButton() {
    return SwitchListTile(
      title: Text('alwaysShowScroll2TopButton'.tr),
      value: PreferenceSetting.alwaysShowScroll2TopButton.value,
      onChanged: PreferenceSetting.saveAlwaysShowScroll2TopButton,
    );
  }

  Widget _buildShowR18GImageDirectly() {
    return ListTile(
      title: Text('showR18GImageDirectly'.tr),
      trailing: Switch(
        value: PreferenceSetting.showR18GImageDirectly.value,
        onChanged: PreferenceSetting.saveShowR18GImageDirectly,
      ),
    );
  }
}
