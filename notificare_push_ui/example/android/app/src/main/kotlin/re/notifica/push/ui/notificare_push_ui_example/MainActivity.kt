package re.notifica.push.ui.notificare_push_ui_example

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import re.notifica.push.NotificarePush

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        NotificarePush.handleTrampolineIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        NotificarePush.handleTrampolineIntent(intent)
    }
}
