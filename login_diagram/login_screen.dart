// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:your_app/feature/auth/presentation/cubits/auth_cubit.dart';
// import 'package:your_app/feature/auth/presentation/cubits/auth_state.dart';

// /// 📱 شاشة تسجيل الدخول
// /// Login Screen with email/password validation and error handling
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   late TextEditingController _emailController;
//   late TextEditingController _passwordController;
//   final _formKey = GlobalKey<FormState>();
//   bool _obscurePassword = true;

//   @override
//   void initState() {
//     super.initState();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   /// التحقق من النموذج واستدعاء Cubit
//   void _handleLogin() {
//     // التحقق من صحة البيانات المدخلة
//     if (_formKey.currentState?.validate() ?? false) {
//       final email = _emailController.text.trim();
//       final password = _passwordController.text;

//       // 🔴 خطوة 1: استدعاء cubit.login()
//       context.read<AuthCubit>().login(
//             email: email,
//             password: password,
//           );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('تسجيل الدخول'),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: BlocListener<AuthCubit, AuthState>(
//         listener: (context, state) {
//           // 🟢 خطوة 6: استجابة للحالات المختلفة
          
//           if (state is AuthLoaded) {
//             // ✅ نجح - المستخدم لديه ملف شامل
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('تم تسجيل الدخول بنجاح'),
//                 backgroundColor: Colors.green,
//                 duration: Duration(seconds: 2),
//               ),
//             );
//             // التوجيه إلى الشاشة الرئيسية
//             Navigator.of(context).pushReplacementNamed('/home');
//           } 
//           else if (state is ProfileIncomplete) {
//             // ⚠️ نجح الدخول لكن الملف ناقص
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('يرجى إكمال بيانات الملف الشخصي'),
//                 backgroundColor: Colors.orange,
//                 duration: Duration(seconds: 2),
//               ),
//             );
//             // التوجيه إلى شاشة إكمال الملف
//             Navigator.of(context).pushReplacementNamed(
//               '/complete-profile',
//               arguments: state.user,
//             );
//           } 
//           else if (state is AuthError) {
//             // ❌ فشل عام
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//                 duration: const Duration(seconds: 3),
//               ),
//             );
//           }
//         },
//         child: BlocBuilder<AuthCubit, AuthState>(
//           builder: (context, state) {
//             final isLoading = state is AuthLoading;

//             return SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // الشعار أو العنوان
//                     const Center(
//                       child: Text(
//                         'مرحباً بك',
//                         style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Center(
//                       child: Text(
//                         'سجل دخولك للمتابعة',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 48),

//                     // حقل البريد الإلكتروني
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         labelText: 'البريد الإلكتروني',
//                         hintText: 'example@email.com',
//                         prefixIcon: const Icon(Icons.email_outlined),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Colors.grey[300]!,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                             color: Colors.blue,
//                             width: 2,
//                           ),
//                         ),
//                       ),
//                       keyboardType: TextInputType.emailAddress,
//                       textInputAction: TextInputAction.next,
//                       enabled: !isLoading,
//                       validator: (value) {
//                         if (value?.isEmpty ?? true) {
//                           return 'البريد الإلكتروني مطلوب';
//                         }
//                         // فحص بسيط للبريد
//                         if (!value!.contains('@') || !value.contains('.')) {
//                           return 'البريد الإلكتروني غير صحيح';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // حقل كلمة المرور
//                     TextFormField(
//                       controller: _passwordController,
//                       decoration: InputDecoration(
//                         labelText: 'كلمة المرور',
//                         hintText: '••••••••',
//                         prefixIcon: const Icon(Icons.lock_outlined),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _obscurePassword
//                                 ? Icons.visibility_off_outlined
//                                 : Icons.visibility_outlined,
//                           ),
//                           onPressed: isLoading
//                               ? null
//                               : () {
//                                   setState(() {
//                                     _obscurePassword = !_obscurePassword;
//                                   });
//                                 },
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Colors.grey[300]!,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                             color: Colors.blue,
//                             width: 2,
//                           ),
//                         ),
//                       ),
//                       obscureText: _obscurePassword,
//                       textInputAction: TextInputAction.done,
//                       enabled: !isLoading,
//                       onFieldSubmitted: (_) {
//                         if (!isLoading) {
//                           _handleLogin();
//                         }
//                       },
//                       validator: (value) {
//                         if (value?.isEmpty ?? true) {
//                           return 'كلمة المرور مطلوبة';
//                         }
//                         if (value!.length < 6) {
//                           return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 8),

//                     // رابط نسيان كلمة المرور
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: isLoading
//                             ? null
//                             : () {
//                                 Navigator.of(context)
//                                     .pushNamed('/forgot-password');
//                               },
//                         child: const Text('نسيت كلمة المرور؟'),
//                       ),
//                     ),
//                     const SizedBox(height: 32),

//                     // زر تسجيل الدخول
//                     ElevatedButton(
//                       onPressed: isLoading ? null : _handleLogin,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         disabledBackgroundColor: Colors.grey[300],
//                       ),
//                       child: isLoading
//                           ? SizedBox(
//                               height: 24,
//                               width: 24,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2.5,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Colors.grey[600]!,
//                                 ),
//                               ),
//                             )
//                           : const Text(
//                               'تسجيل الدخول',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                     ),
//                     const SizedBox(height: 24),

//                     // فاصل
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Divider(
//                             color: Colors.grey[300],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           child: Text(
//                             'أو',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Divider(
//                             color: Colors.grey[300],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),

//                     // روابط إضافية
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           'ليس لديك حساب؟ ',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         TextButton(
//                           onPressed: isLoading
//                               ? null
//                               : () {
//                                   Navigator.of(context).pushNamed('/signup');
//                                 },
//                           style: TextButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                           ),
//                           child: const Text(
//                             'أنشئ حساباً جديداً',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
