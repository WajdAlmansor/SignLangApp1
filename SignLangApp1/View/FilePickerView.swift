import SwiftUI
import Speech

struct FilePickerView: View {
    @StateObject private var viewModel = FilePickerViewModel() // نربط الواجهة مع ViewModel اللي يخزن البيانات ويتعامل مع المنطق
    @State private var isFilePickerPresented = false // يتحكم إذا نافذة اختيار الملفات مفتوحة أو لا

    var body: some View {
        VStack {
            // إذا فيه نص تم تحويله من الملف الموجود في Bundle
            if let transcription = viewModel.transcriptionResult {
                Text("ترجمة الملف: \(transcription)") // تعرض النص الناتج
                    .padding()
            } else {
                Text("لا يوجد نص مترجم حتى الآن") // إذا ما فيه نص تعرض رسالة
                    .foregroundColor(.gray)
                    .padding()
            }

            // إذا فيه رسالة خطأ
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage) // تعرض رسالة الخطأ
                    .foregroundColor(.red)
                    .padding()
            }

            // زر لتحويل الملف الموجود في Bundle إلى نص
            Button(action: {
                viewModel.transcribeAudioFromBundle() // استدعاء الدالة لتحويل الملف
            }) {
                Text("ترجمة ملف Bundle") // نص الزر
                    .font(.headline)
                    .padding()
                    .background(Color.orange) // خلفية الزر برتقالية
                    .foregroundColor(.white) // النص أبيض
                    .cornerRadius(10) // الزوايا مستديرة
            }
            .padding(.bottom)

            // زر يفتح نافذة اختيار الملف
            Button(action: {
                isFilePickerPresented.toggle() // يغير الحالة عشان يعرض نافذة اختيار الملف
            }) {
                Text("اختر ملف mpeg-4") // نص الزر
                    .font(.headline)
                    .padding()
                    .background(Color.blue) // خلفية الزر زرقاء
                    .foregroundColor(.white) // النص أبيض
                    .cornerRadius(10) // الزوايا مستديرة
            }

            // إذا تم اختيار ملف
            if viewModel.selectedFile != nil {
                // زر تحويل الملف إلى نص
                Button(action: {
                    viewModel.transcribeSelectedFile() // يستدعي دالة التحويل
                }) {
                    Text("Transcribe File") // نص الزر
                        .font(.headline)
                        .padding()
                        .background(Color.green) // خلفية الزر خضراء
                        .foregroundColor(.white) // النص أبيض
                        .cornerRadius(10) // الزوايا مستديرة
                }
                .padding(.top) // مسافة بين الأزرار
            }
        }
        .fileImporter(
            isPresented: $isFilePickerPresented, // إذا كانت النافذة مفتوحة أو لا
            allowedContentTypes: [.audio, .movie], // يسمح فقط باختيار ملفات الصوت والفيديو
            allowsMultipleSelection: false // يسمح باختيار ملف واحد فقط
        ) { result in
            // يتعامل مع النتيجة بعد اختيار الملف
            switch result {
            case .success(let urls): // إذا تم اختيار ملف بنجاح
                viewModel.processPickedFile(url: urls.first) // يعالج الملف المختار
            case .failure(let error): // إذا صار خطأ
                viewModel.errorMessage = "Error selecting file: \(error.localizedDescription)" // يعرض رسالة الخطأ
            }
        }
        .padding() // مسافة حول كل العناصر
    }
}

#Preview {
    FilePickerView() // يعرض المعاينة للتجربة
}
