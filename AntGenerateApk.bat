@ECHO ON & setLocal enableDelayedExpansion
@color 5e
@echo ============================================׼������=====================================================
@rem ==============================start,������Щ����������Ҫ�����Լ�����������=========================
@set CUR_DIR=%~dp0
@set TARGET_DIR=%CUR_DIR%out\target\
@cd %CUR_DIR%
@rem ��ת�룬��ant.properties�е�����ת��utf-8
@call native2ascii -encoding utf-8 ant.properties ant_utf8.properties
@rem ɾ��Ŀ��Ŀ¼�µ������ļ����������ļ���
@rem del %TARGET_DIR%
@rem ---------------------------------------------------------------------------------------------------------
@set chooseVersion=1
@rem ���ɲ�ͬ�汾��apk
@echo .
@echo .
@echo .
@echo .
@echo .
@echo =========�����ͬ�汾��apk�˵�===========
@echo * * * * * * * * * * * * * * * * * * * * *
@echo *                                       *
@echo *   1: release�汾                      *
@echo *                                       *
@echo *   2: debug�汾                        *
@echo *                                       *
@echo *   3: �˳�����                         *
@echo *                                       *
@echo * * * * * * * * * * * * * * * * * * * * *
@echo =========================================
@echo .
@echo .
@echo .
@echo .
:menu
@set /p input=����Ҫ����İ汾���:
@if "%input%"=="1" goto release
@if "%input%"=="2" goto debug
@if "%input%"=="3" goto end
@echo =========ERROR:��������ȷ�ı��==============
@goto menu
:release
@cd %projectpath%
@echo ��ѡ�����   - release�汾 
@echo           .
@echo           .         .
@echo           .         .       .
@set chooseVersion=1
@call ant copy_files_release

@goto secondstep
:debug
@cd %projectpath%
@echo ��ѡ�����  - debug�汾
@echo           .
@echo           .         .
@echo           .         .       .
@set chooseVersion=2
@call ant copy_files_debug

@goto secondstep

:secondstep
@rem ȷ��AndroidManifest�İ汾��
@rem ��ӡ��ǰ�汾�Ÿ��û�
@echo ======================��ǰ�汾��===========================
@call python %CUR_DIR%\config\getVersion.py
@echo ========��������ѡ������Ϊ��˽�˶���һ���汾��===========
@call python %CUR_DIR%\config\chooseVersion.py %chooseVersion%
@echo ===========================================================
@set /p input=ͬ��������1���������ֶ�����汾��
@if "%input%"=="1" goto thirdstep
:version
@set /p input=�ֶ�����һ��VersionCode��
@set versionCode=%input%
@set /p input=�ֶ�����һ��VersionName:
@set versionName=%input%
@echo ===========������İ汾�����£�===================
@echo VersionCode = %versionCode%
@echo VersionName = %versionName%
@set /p input=ȷ��������1���������������룺
@if "%input%"=="1" goto forthsetp
@goto version

:thirdstep
@rem �ö��Ƶ�versioncode��versionname,�޸�AndroidManifest�İ汾��
@call python %CUR_DIR%\config\setVersionOne.py %chooseVersion%
goto fifthstep

:forthsetp
@rem ���ֶ������versioncode��versionname���޸İ汾��
@call python %CUR_DIR%\config\setVersionTwo.py %versionCode% %versionName% %chooseVersion%
goto fifthstep

:fifthstep
@rem ��ʽ��ʼ����
@call ant android_release
@echo ����APK���

:end
@echo ====================!!����ִ�н���!!=======================
@pause