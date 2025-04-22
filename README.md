# ci_cd_mobile

### 📱 `mobile`

1. Dans `mobile`
    ```bash
    flutter pub get
    ```
2. Modifie l'URL de l'API dans lib/Service/api_sevrice.dart:
    ```dart	
    final String baseUrl ="http://X.X.X.X:3000";
    ```
3. Lance l'application mobile:
    ```bash
    flutter run 
    ```
4. Vérifiez que:
- Les données apparaissent dans l’application
- L’interface réagit correctement même en cas d’erreur
