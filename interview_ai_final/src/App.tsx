import { useState, useEffect, useRef } from 'react';
import { 
  Smartphone, 
  Code, 
  FolderTree, 
  Palette, 
  Play, 
  ArrowRight,
  ArrowLeft,
  Mail, 
  Lock, 
  Eye, 
  EyeOff, 
  User, 
  FileText,
  Bookmark, 
  History, 
  PersonStanding, 
  Lightbulb, 
  Mic, 
  Send, 
  ChevronRight, 
  Award, 
  Sparkles, 
  Volume2, 
  CheckCircle, 
  AlertTriangle,
  LogOut,
  Sliders,
  Bell,
  Fingerprint,
  PieChart,
  Grid,
  Camera,
  Check,
  Edit2
} from 'lucide-react';

// Define the simulated screens list
const SCREENS = [
  { id: 'splash', name: 'Splash Screen', category: 'General' },
  { id: 'onboarding1', name: 'Onboarding 1 (Intro)', category: 'Onboarding' },
  { id: 'onboarding2', name: 'Onboarding 2 (Live AI)', category: 'Onboarding' },
  { id: 'onboarding3', name: 'Onboarding 3 (Growth)', category: 'Onboarding' },
  { id: 'login', name: 'Login Screen', category: 'Auth' },
  { id: 'register', name: 'Register Screen', category: 'Auth' },
  { id: 'forgot', name: 'Forgot Password', category: 'Auth' },
  { id: 'dashboard', name: 'Home Dashboard', category: 'Dashboard' },
  { id: 'category', name: 'Choose Category', category: 'Dashboard' },
  { id: 'practice', name: 'Practice Question', category: 'Dashboard' },
  { id: 'feedback', name: 'Score & Feedback', category: 'Dashboard' },
  { id: 'details', name: 'Session Details', category: 'Dashboard' },
  { id: 'history', name: 'Past History', category: 'Dashboard' },
  { id: 'profile', name: 'User Profile', category: 'Profile' }
];

// Define code file structure to show to developers
const FLUTTER_CODE_FILES = [
  {
    path: 'lib/main.dart',
    label: 'main.dart',
    type: 'root',
    code: `import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/colors.dart';
import 'core/theme/typography.dart';
import 'features/home/splash_screen.dart';
import 'features/home/onboarding_screens.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/dashboard/dashboard_screen.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreens()),
    GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
    GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),
    GoRoute(path: '/forgot-password', builder: (c, s) => const ForgotPasswordScreen()),
    GoRoute(path: '/dashboard', builder: (c, s) => const DashboardScreen()),
  ],
);

void main() => runApp(const ProviderScope(child: InterviewApp()));

class InterviewApp extends StatelessWidget {
  const InterviewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'InterviewAI',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: AppTypography.textTheme,
      ),
    );
  }
}`
  },
  {
    path: 'lib/core/theme/colors.dart',
    label: 'colors.dart',
    type: 'core',
    code: `import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF3525CD);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF712AE2);
  static const Color secondaryContainer = Color(0xFF8A4CFC);
  static const Color background = Color(0xFFF8F9FF);
  static const Color onBackground = Color(0xFF0B1C30);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color outlineVariant = Color(0xFFC7C4D8);
  static const Color error = Color(0xFFBA1A1A);
}`
  },
  {
    path: 'lib/core/theme/typography.dart',
    label: 'typography.dart',
    type: 'core',
    code: `import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  static const String fontFamily = 'Inter';

  static TextStyle get headlineLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 38 / 30,
        color: AppColors.onBackground,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
      );
}`
  },
  {
    path: 'lib/shared/widgets/custom_button.dart',
    label: 'custom_button.dart',
    type: 'shared',
    code: `import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const CustomButton({Key? key, required this.text, required this.onPressed, this.icon}) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
      lowerBound: 0.0,
      upperBound: 0.03, // compresses to 0.97
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: widget.onPressed,
            child: Text(widget.text),
          ),
        ),
      ),
    );
  }
}`
  },
  {
    path: 'lib/shared/widgets/custom_card.dart',
    label: 'custom_card.dart',
    type: 'shared',
    code: `import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final Color? borderLeftColor;

  const CustomCard({Key? key, required this.child, this.borderLeftColor}) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered 
                    ? AppColors.primary.withOpacity(0.4) 
                    : AppColors.outlineVariant.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered 
                      ? AppColors.primary.withOpacity(0.08) 
                      : const Color(0x0A0F172A),
                  blurRadius: _isHovered ? 20 : 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}`
  },
  {
    path: 'lib/features/home/splash_screen.dart',
    label: 'splash_screen.dart',
    type: 'features',
    code: `class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      context.go('/onboarding');
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('InterviewAI')));
  }
}`
  },
  {
    path: 'lib/features/home/onboarding_screens.dart',
    label: 'onboarding_screens.dart',
    type: 'features',
    code: `class OnboardingScreens extends StatelessWidget {
  // Configured as a PageView implementing Master Your Interviews,
  // Live AI feedback with circle progress ring, and Track your growth.
}`
  },
  {
    path: 'lib/features/dashboard/dashboard_screen.dart',
    label: 'dashboard_screen.dart',
    type: 'features',
    code: `class DashboardScreen extends StatelessWidget {
  // Realizes clean welcome greeting "Hi Alex", bento stats tracking sessions,
  // and direct navigational pathways to practice and profiling.
}`
  },
  {
    path: 'lib/core/theme/theme.dart',
    label: 'theme.dart',
    type: 'theme',
    code: `import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),

      textTheme: AppTypography.textTheme,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceContainerLowest,
        foregroundColor: AppColors.onBackground,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 2.0,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.onBackground,
          fontWeight: FontWeight.bold,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
          textStyle: AppTypography.buttonText,
        ),
      ),
    );
  }
}`
  },
  {
    path: 'lib/shared/widgets/buttons/elevated_button.dart',
    label: 'elevated_button.dart',
    type: 'shared',
    code: `import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 12.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgProperty = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return theme.colorScheme.onSurface.withOpacity(0.12);
      }
      return backgroundColor ?? theme.colorScheme.primary;
    });

    final fgProperty = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return theme.colorScheme.onSurface.withOpacity(0.38);
      }
      return foregroundColor ?? theme.colorScheme.onPrimary;
    });

    final buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ).copyWith(
      backgroundColor: bgProperty,
      foregroundColor: fgProperty,
    );

    return icon != null 
        ? ElevatedButton.icon(onPressed: onPressed, style: buttonStyle, icon: icon!, label: child)
        : ElevatedButton(onPressed: onPressed, style: buttonStyle, child: child);
  }
}`
  },
  {
    path: 'lib/shared/widgets/buttons/outlined_button.dart',
    label: 'outlined_button.dart',
    type: 'shared',
    code: `import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final Color? borderColor;
  final Color? foregroundColor;
  final double borderRadius;

  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.borderColor,
    this.foregroundColor,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final borderProperty = WidgetStateProperty.resolveWith<BorderSide?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12));
      }
      return BorderSide(color: borderColor ?? theme.colorScheme.outline);
    });

    final fgProperty = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return theme.colorScheme.onSurface.withOpacity(0.38);
      }
      return foregroundColor ?? theme.colorScheme.primary;
    });

    final buttonStyle = OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
    ).copyWith(
      side: borderProperty,
      foregroundColor: fgProperty,
    );

    return icon != null
        ? OutlinedButton.icon(onPressed: onPressed, style: buttonStyle, icon: icon!, label: child)
        : OutlinedButton(onPressed: onPressed, style: buttonStyle, child: child);
  }
}`
  },
  {
    path: 'lib/shared/widgets/buttons/text_button.dart',
    label: 'text_button.dart',
    type: 'shared',
    code: `import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final Color? foregroundColor;

  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fgProperty = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return theme.colorScheme.onSurface.withOpacity(0.38);
      }
      return foregroundColor ?? theme.colorScheme.primary;
    });

    final buttonStyle = TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ).copyWith(
      foregroundColor: fgProperty,
    );

    return icon != null
        ? TextButton.icon(onPressed: onPressed, style: buttonStyle, icon: icon!, label: child)
        : TextButton(onPressed: onPressed, style: buttonStyle, child: child);
  }
}`
  }
];

export default function App() {
  const [activeScreen, setActiveScreen] = useState('splash');
  const [activeTab, setActiveTab] = useState<'preview' | 'code' | 'specs'>('preview');
  const [selectedFile, setSelectedFile] = useState<typeof FLUTTER_CODE_FILES[0]>(FLUTTER_CODE_FILES[0]);
  const [emailText, setEmailText] = useState('');
  const [passwordText, setPasswordText] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [responseInputText, setResponseInputText] = useState('');
  const [showHint, setShowHint] = useState(false);
  const [isPlayingAudio, setIsPlayingAudio] = useState(false);
  const [audioProgress, setAudioProgress] = useState(30);

  // Editable Profile state variables
  const [profileName, setProfileName] = useState('Alex Mercer');
  const [profileEmail, setProfileEmail] = useState('alex.mercer@example.com');
  const [profilePhone, setProfilePhone] = useState('+1 (555) 019-2834');
  const [profileTitle, setProfileTitle] = useState('Senior Software Engineer');
  const [profileBio, setProfileBio] = useState('Senior Software Engineer specialized in clean architecture and cloud scalability.');
  const [profilePhoto, setProfilePhoto] = useState('https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200');
  const [isEditingProfile, setIsEditingProfile] = useState(false);
  const [editingName, setEditingName] = useState('Alex Mercer');
  const [editingEmail, setEditingEmail] = useState('alex.mercer@example.com');
  const [editingPhone, setEditingPhone] = useState('+1 (555) 019-2834');
  const [editingTitle, setEditingTitle] = useState('Senior Software Engineer');
  const [editingBio, setEditingBio] = useState('Senior Software Engineer specialized in clean architecture and cloud scalability.');
  const [editingPhoto, setEditingPhoto] = useState('https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200');

  const handleStartEditing = () => {
    setEditingName(profileName);
    setEditingEmail(profileEmail);
    setEditingPhone(profilePhone);
    setEditingTitle(profileTitle);
    setEditingBio(profileBio);
    setEditingPhoto(profilePhoto);
    setIsEditingProfile(true);
  };

  const handleSaveProfile = () => {
    setProfileName(editingName);
    setProfileEmail(editingEmail);
    setProfilePhone(editingPhone);
    setProfileTitle(editingTitle);
    setProfileBio(editingBio);
    setProfilePhoto(editingPhoto);
    setIsEditingProfile(false);
  };

  const [isListening, setIsListening] = useState(false);
  const [speechFeedback, setSpeechFeedback] = useState<string | null>(null);
  const [listeningError, setListeningError] = useState<string | null>(null);
  const recognitionRef = useRef<any>(null);
  const simulatedTimerRef = useRef<any>(null);

  const startSimulatedSpeech = () => {
    setSpeechFeedback("Simulating voice input (Sandbox Fallback)...");
    
    const phrases = [
      "I have extensive experience building high-performance server components.",
      "In my past role, I successfully optimized rendering and state synchronization workflows.",
      "I apply the STAR methodology: identifying situations, outlining clear objectives, taking precise action, and achieving outstanding results."
    ];
    
    let phraseIndex = 0;
    
    simulatedTimerRef.current = setTimeout(() => {
      setSpeechFeedback(`Dictating: "${phrases[phraseIndex]}"`);
      setResponseInputText((prev) => prev ? prev + ' ' + phrases[phraseIndex] : phrases[phraseIndex]);
      phraseIndex++;

      const interval = setInterval(() => {
        if (phraseIndex < phrases.length) {
          setSpeechFeedback(`Dictating: "${phrases[phraseIndex]}"`);
          setResponseInputText((prev) => prev ? prev + ' ' + phrases[phraseIndex] : phrases[phraseIndex]);
          phraseIndex++;
        } else {
          clearInterval(interval);
          setSpeechFeedback("Voice input finished! Click microphone icon to start again.");
          setIsListening(false);
          setTimeout(() => setSpeechFeedback(null), 3500);
        }
      }, 3000);

      simulatedTimerRef.current = interval;
    }, 1500);
  };

  const toggleSpeechRecognition = async () => {
    if (isListening) {
      if (recognitionRef.current) {
        try {
          recognitionRef.current.stop();
        } catch (e) {
          console.error(e);
        }
      }
      if (simulatedTimerRef.current) {
        clearTimeout(simulatedTimerRef.current);
        clearInterval(simulatedTimerRef.current);
        simulatedTimerRef.current = null;
      }
      setIsListening(false);
      setSpeechFeedback(null);
    } else {
      setIsListening(true);
      setSpeechFeedback("Requesting microphone permission...");
      setListeningError(null);

      // Explicitly request user microphone permission via MediaDevices API
      let permissionGranted = false;
      try {
        if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
          const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
          // Explicitly stop all tracks to release the microphone resource immediately
          stream.getTracks().forEach((track) => track.stop());
          permissionGranted = true;
        } else {
          console.warn("navigator.mediaDevices.getUserMedia is not supported on this browser.");
        }
      } catch (permissionErr: any) {
        console.warn("Microphone permission denied or error requesting permission:", permissionErr);
        setSpeechFeedback("Permission denied! Running fallback...");
        // Delay slightly before starting the fallback so the user reads the denial status
        setTimeout(() => {
          startSimulatedSpeech();
        }, 1200);
        return;
      }

      setSpeechFeedback("Initializing speech engine...");

      const SpeechRecognitionAPI = (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;
      
      if (SpeechRecognitionAPI) {
        try {
          const rec = new SpeechRecognitionAPI();
          rec.continuous = true;
          rec.interimResults = true;
          rec.lang = 'en-US';

          rec.onstart = () => {
            setSpeechFeedback("Microphone active... Dictate now");
          };

          rec.onresult = (event: any) => {
            let finalTranscript = '';
            for (let i = event.resultIndex; i < event.results.length; ++i) {
              if (event.results[i].isFinal) {
                finalTranscript += event.results[i][0].transcript;
              }
            }
            if (finalTranscript) {
              setResponseInputText((prev) => prev ? prev + ' ' + finalTranscript : finalTranscript);
            }
          };

          rec.onerror = (event: any) => {
            console.warn('Speech recognition interface error/restriction, activating simulator fallback:', event.error);
            startSimulatedSpeech();
          };

          rec.onend = () => {
            // Handled natural ending if needed
          };

          recognitionRef.current = rec;
          rec.start();
        } catch (err) {
          console.warn('Speech instantiation error, starting simulator:', err);
          startSimulatedSpeech();
        }
      } else {
        startSimulatedSpeech();
      }
    }
  };

  useEffect(() => {
    return () => {
      if (simulatedTimerRef.current) {
        clearTimeout(simulatedTimerRef.current);
        clearInterval(simulatedTimerRef.current);
      }
      if (recognitionRef.current) {
        try {
          recognitionRef.current.stop();
        } catch (e) {}
      }
    };
  }, []);

  // Splash auto-redirect simulator
  useEffect(() => {
    if (activeScreen === 'splash') {
      const timer = setTimeout(() => {
        setActiveScreen('onboarding1');
      }, 3000);
      return () => clearTimeout(timer);
    }
  }, [activeScreen]);

  // Audio timer simulation
  useEffect(() => {
    let interval: any;
    if (isPlayingAudio) {
      interval = setInterval(() => {
        setAudioProgress((prev) => {
          if (prev >= 100) {
            setIsPlayingAudio(false);
            return 0;
          }
          return prev + 1;
        });
      }, 200);
    }
    return () => clearInterval(interval);
  }, [isPlayingAudio]);

  const selectScreenAndSyncCode = (screenId: string) => {
    setActiveScreen(screenId);
    // Auto map screen selection to corresponding relevant code files for immersive dev feel
    if (screenId.startsWith('onboarding')) {
      const file = FLUTTER_CODE_FILES.find(f => f.path.includes('onboarding'));
      if (file) setSelectedFile(file);
    } else if (screenId === 'login' || screenId === 'register' || screenId === 'forgot') {
      const file = FLUTTER_CODE_FILES.find(f => f.path.includes('colors.dart'));
      if (file) setSelectedFile(file);
    } else if (screenId === 'splash') {
      const file = FLUTTER_CODE_FILES.find(f => f.path.includes('splash'));
      if (file) setSelectedFile(file);
    } else {
      const file = FLUTTER_CODE_FILES.find(f => f.path.includes('dashboard'));
      if (file) setSelectedFile(file);
    }
  };

  return (
    <div id="ai_playground" className="min-h-screen bg-[#070a1e] text-slate-100 flex flex-col font-sans selection:bg-indigo-500 selection:text-white relative overflow-hidden">
      {/* Dynamic background glow underlays to highlight the glassmorphism effect */}
      <div className="absolute top-0 right-0 w-[50vw] h-[50vw] max-w-[600px] bg-indigo-600/10 rounded-full blur-[150px] pointer-events-none" />
      <div className="absolute bottom-0 left-0 w-[50vw] h-[50vw] max-w-[600px] bg-purple-600/10 rounded-full blur-[150px] pointer-events-none" />
      
      {/* Upper Brand Info Line */}
      <header className="border-b border-white/5 bg-slate-950/30 backdrop-blur-md px-6 py-4 flex items-center justify-between sticky top-0 z-50">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-indigo-600 flex items-center justify-center shadow-lg shadow-indigo-600/30">
            <Sparkles className="w-5 h-5 text-white animate-pulse" />
          </div>
          <div>
            <h1 className="text-lg font-bold tracking-tight text-white flex items-center gap-2">
              InterviewAI <span className="text-[10px] bg-indigo-950 text-indigo-400 font-mono font-medium px-2 py-0.5 rounded-full border border-indigo-700/50">Flutter Arch</span>
            </h1>
            <p className="text-xs text-slate-400">High-fidelity React prototype + Production-ready Clean Architecture Dart Codebase</p>
          </div>
        </div>
        
        <div className="flex items-center gap-2">
          {/* Quick interactive screen selector drop-down */}
          <div className="flex items-center gap-1.5 bg-white/5 border border-white/10 backdrop-blur-md rounded-lg px-3 py-1.5 shadow-sm">
            <span className="text-xs text-slate-300 font-medium">Quick Screen Select:</span>
            <select 
              value={activeScreen} 
              onChange={(e) => selectScreenAndSyncCode(e.target.value)}
              className="bg-transparent text-xs font-semibold text-indigo-400 focus:outline-none cursor-pointer"
            >
              {SCREENS.map(sc => (
                <option key={sc.id} value={sc.id} className="bg-slate-900 text-slate-300">
                  [{sc.category}] {sc.name}
                </option>
              ))}
            </select>
          </div>
        </div>
      </header>

      {/* Main Content Layout splits into Screen Mockup Simulator and Developer Workspace */}
      <div className="flex-1 flex flex-col lg:flex-row min-h-0 relative z-10">
        
        {/* LEFT COLUMN: The Interactive Device Simulator with soft shadows */}
        <div className="flex-1 bg-transparent flex flex-col items-center justify-center p-6 lg:border-r border-white/5 relative">
          <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,rgba(99,102,241,0.03),transparent_70%)] pointer-events-none" />
          
          <div className="relative w-full max-w-[340px] aspect-[9/19.5] max-h-[720px] bg-slate-950/80 rounded-[48px] p-3.5 shadow-[0_25px_60px_-15px_rgba(0,0,0,0.7)] border border-white/10 flex flex-col relative overflow-hidden transition-all duration-300 ring-1 ring-white/10">
            {/* Notch and speaker simulation */}
            <div className="absolute top-0 left-1/2 -translate-x-1/2 h-6 w-36 bg-black rounded-b-2xl z-50 flex items-center justify-center gap-1.5">
              <div className="w-12 h-1 bg-neutral-900 rounded-full" />
              <div className="w-2.5 h-2.5 bg-neutral-900 rounded-full" />
            </div>

            {/* Inner Phone Screen frame */}
            <div className="flex-1 w-full bg-gradient-to-tr from-[#edf1ff] via-[#fbf5f9] to-[#f2fcff] text-[#0b1c30] rounded-[36px] overflow-hidden flex flex-col relative z-20 font-sans shadow-inner text-sm select-none">
              {/* Vibrant fluid pastel blob lights under the frosted cards */}
              <div className="absolute top-[-25%] left-[-20%] w-[100%] h-[80%] bg-indigo-300/35 rounded-full blur-[45px] pointer-events-none" />
              <div className="absolute bottom-[-20%] right-[-15%] w-[90%] h-[75%] bg-pink-300/35 rounded-full blur-[45px] pointer-events-none" />
              <div className="absolute top-[35%] left-[10%] w-[60%] h-[50%] bg-sky-200/40 rounded-full blur-[40px] pointer-events-none" />
              
              {/* TOP HEADER SECTION (If screen is not full-bleed) */}
              {!['splash'].includes(activeScreen) && (
                <div className="pt-8 px-4 pb-2 flex items-center justify-between text-[#0b1c30] bg-white/20 backdrop-blur-md border-b border-white/30 sticky top-0 z-30">
                  <button 
                    onClick={() => {
                      // Custom interactive backtrack flow
                      if (activeScreen === 'onboarding2') setActiveScreen('onboarding1');
                      else if (activeScreen === 'onboarding3') setActiveScreen('onboarding2');
                      else if (activeScreen === 'login' || activeScreen === 'register') setActiveScreen('onboarding3');
                      else if (activeScreen === 'forgot') setActiveScreen('login');
                      else if (activeScreen === 'category') setActiveScreen('dashboard');
                      else if (activeScreen === 'practice') setActiveScreen('category');
                      else if (activeScreen === 'feedback') setActiveScreen('practice');
                      else if (activeScreen === 'details') setActiveScreen('history');
                      else if (activeScreen === 'history' || activeScreen === 'profile') setActiveScreen('dashboard');
                      else setActiveScreen('onboarding1');
                    }}
                    className="w-8 h-8 rounded-full flex items-center justify-center bg-white/30 hover:bg-white/50 hover:scale-105 active:scale-90 text-indigo-700 shadow-sm border border-white/40 transitions-all duration-150 cursor-pointer"
                  >
                    <ArrowLeft className="w-4 h-4" />
                  </button>
                  <span className="font-extrabold text-sm text-indigo-950 tracking-tight">Interview Pro</span>
                  <div className="w-8 h-8" />
                </div>
              )}

              {/* ACTIVE VIEW WRAPPERS */}
              <div className="flex-1 flex flex-col overflow-y-auto overflow-x-hidden relative">
                
                {/* 1. SPLASH SCREEN STATE */}
                {activeScreen === 'splash' && (
                  <div className="flex-1 bg-white/20 backdrop-blur-xl flex flex-col justify-between items-center py-12 px-6 text-center animate-fade-in relative z-10">
                    <div className="flex-1 flex flex-col items-center justify-center">
                      <div className="w-[100px] h-[100px] rounded-3xl bg-gradient-to-tr from-indigo-600 to-purple-500 shadow-xl shadow-indigo-700/30 mb-6 flex items-center justify-center relative overflow-hidden group border border-white/20 hover:scale-105 hover:rotate-1 duration-300 transition-all">
                        <div className="absolute inset-0 bg-white/15 opacity-30 transform -skew-x-12 group-hover:skew-x-12 duration-500" />
                        <span className="text-white text-3xl font-extrabold font-mono">iAI</span>
                      </div>
                      <h2 className="text-3xl font-black text-indigo-950 tracking-tight font-sans">InterviewAI</h2>
                      <p className="text-xs text-indigo-600 font-bold uppercase tracking-wider mt-2.5">The Expert Coach</p>
                    </div>
                    <div className="flex flex-col items-center gap-2">
                      <div className="w-7 h-7 border-4 border-indigo-600 border-t-transparent rounded-full animate-spin" />
                      <button onClick={() => setActiveScreen('onboarding1')} className="text-xs text-indigo-700 font-bold hover:underline mt-2">Skip Loader</button>
                    </div>
                  </div>
                )}

                {/* 2. ONBOARDING SCREEN 1 */}
                {activeScreen === 'onboarding1' && (
                  <div className="flex-1 flex flex-col justify-between p-5 text-center bg-transparent backdrop-blur-md relative z-10 animate-fade-in">
                    <div className="flex justify-end">
                      <button onClick={() => setActiveScreen('register')} className="text-sm font-bold text-indigo-700 hover:text-indigo-950 hover:scale-105 active:scale-95 transition-all duration-150 cursor-pointer">Skip</button>
                    </div>
                    <div className="my-auto flex flex-col items-center px-2">
                      <div className="w-full aspect-square max-w-[180px] rounded-[2rem] bg-white/40 border border-white/50 backdrop-blur-sm flex items-center justify-center p-6 mb-6 shadow-md hover:scale-105 hover:-translate-y-1 hover:shadow-lg transition-all duration-300">
                        <div className="w-16 h-16 rounded-full bg-amber-100 flex items-center justify-center shadow-md">
                          <Award className="w-10 h-10 text-amber-500" />
                        </div>
                      </div>
                      <h2 className="text-xl font-bold text-indigo-950 leading-tight">Master Your Interviews</h2>
                      <p className="text-sm text-neutral-600 font-medium mt-3 max-w-[240px]">Practice realistic mock interviews tailored to your industry and get instant feedback.</p>
                    </div>
                    <div className="flex flex-col items-center gap-4">
                      <div className="flex gap-2">
                        <span className="w-6 h-2 rounded-full bg-indigo-650 shadow-sm shadow-indigo-600/30" />
                        <span className="w-2 h-2 rounded-full bg-white/60 border border-white/40" />
                        <span className="w-2 h-2 rounded-full bg-white/60 border border-white/40" />
                      </div>
                      <button 
                        onClick={() => setActiveScreen('onboarding2')}
                        className="w-full h-12 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-semibold flex items-center justify-center gap-2 shadow-lg shadow-indigo-600/20 hover:shadow-indigo-600/35 hover:-translate-y-0.5 active:translate-y-0 active:scale-95 transition-all duration-200 border border-indigo-500/10 cursor-pointer"
                      >
                        Next <ArrowRight className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                )}

                {/* 3. ONBOARDING SCREEN 2 */}
                {activeScreen === 'onboarding2' && (
                  <div className="flex-1 flex flex-col justify-between p-5 text-center bg-transparent backdrop-blur-md relative z-10 animate-fade-in">
                    <div className="flex justify-end">
                      <button onClick={() => setActiveScreen('register')} className="text-sm font-bold text-indigo-700 hover:text-indigo-950 hover:scale-105 active:scale-95 transition-all duration-150 cursor-pointer">Skip</button>
                    </div>
                    <div className="my-auto flex flex-col items-center px-2">
                      {/* Phone mockup previewing score feedback */}
                      <div className="w-[180px] h-[220px] bg-white/45 backdrop-blur-sm border border-white/55 shadow-lg rounded-3xl p-3.5 flex flex-col gap-3 relative mb-6 hover:scale-105 hover:-translate-y-1 hover:shadow-xl transition-all duration-300">
                        <div className="relative w-18 h-18 mx-auto flex items-center justify-center shrink-0">
                          <svg className="absolute inset-0 w-full h-full transform -rotate-90" viewBox="0 0 100 100">
                            <circle cx="50" cy="50" r="42" fill="none" stroke="rgba(99, 102, 241, 0.15)" strokeWidth="8" />
                            <circle cx="50" cy="50" r="42" fill="none" stroke="#6366f1" strokeWidth="8" strokeDasharray="263" strokeDashoffset="40" />
                          </svg>
                          <div className="flex flex-col items-center">
                            <span className="text-base font-black text-indigo-950">85</span>
                            <span className="text-[7px] text-indigo-700 font-extrabold uppercase tracking-wider">Strong</span>
                          </div>
                        </div>
                        <div className="flex flex-col gap-1.5 text-left shrink-0">
                          <div className="bg-white/60 backdrop-blur-sm border border-white/60 rounded-lg p-1.5 flex items-start gap-1.5 border-l-2 border-l-indigo-600 shadow-sm hover:scale-103 hover:shadow-md hover:translate-x-0.5 duration-200 transition-all">
                            <FileText className="w-3.5 h-3.5 text-indigo-600 shrink-0 mt-0.5" />
                            <div className="flex flex-col">
                              <span className="text-[8px] font-bold text-indigo-950">Structure</span>
                              <span className="text-[7px] text-neutral-600">STAR method detected.</span>
                            </div>
                          </div>
                        </div>
                      </div>
                      <h2 className="text-xl font-bold text-indigo-950 leading-tight">Real-time AI Feedback</h2>
                      <p className="text-sm text-neutral-600 font-medium mt-3 max-w-[240px]">Our AI analyzes responses for structure, tone, and content to provide actionable insights.</p>
                    </div>
                    <div className="flex flex-col items-center gap-4">
                      <div className="flex gap-2">
                        <span className="w-2 h-2 rounded-full bg-white/60 border border-white/40" />
                        <span className="w-6 h-2 rounded-full bg-indigo-650 shadow-sm shadow-indigo-600/30" />
                        <span className="w-2 h-2 rounded-full bg-white/60 border border-white/40" />
                      </div>
                      <button 
                        onClick={() => setActiveScreen('onboarding3')}
                        className="w-full h-12 bg-indigo-600 hover:bg-indigo-750 text-white rounded-xl font-semibold flex items-center justify-center gap-2 shadow-lg shadow-indigo-600/20 active:scale-95 duration-100 border border-indigo-550 cursor-pointer hover:shadow-indigo-600/35 hover:-translate-y-0.5 active:translate-y-0 transition-all duration-200"
                      >
                        Next
                      </button>
                    </div>
                  </div>
                )}

                {/* 4. ONBOARDING SCREEN 3 */}
                {activeScreen === 'onboarding3' && (
                  <div className="flex-1 flex flex-col justify-between p-5 text-center bg-transparent backdrop-blur-md relative z-10 animate-fade-in">
                    <div className="flex justify-end">
                      <button onClick={() => setActiveScreen('register')} className="text-sm font-bold text-indigo-700 hover:text-indigo-950 hover:scale-105 active:scale-95 transition-all duration-150 cursor-pointer">Skip</button>
                    </div>
                    <div className="my-auto flex flex-col items-center px-2">
                      <div className="w-full aspect-square max-w-[180px] rounded-[2rem] bg-white/40 border border-white/50 backdrop-blur-sm flex items-center justify-center p-6 mb-6 shadow-md relative hover:scale-105 hover:-translate-y-1 hover:shadow-lg transition-all duration-300">
                        <Award className="w-16 h-16 text-[#ef7e0a]" />
                        <div className="absolute bottom-4 right-4 bg-white/75 backdrop-blur-sm px-2 py-1 rounded-xl shadow-md border border-white/50 flex items-center gap-1 hover:scale-105 transition-all">
                          <span className="text-[8px] font-black text-indigo-650">+24%</span>
                        </div>
                      </div>
                      <h2 className="text-xl font-bold text-indigo-950 leading-tight">Track Your Growth</h2>
                      <p className="text-sm text-neutral-600 font-medium mt-3 max-w-[240px]">Save your sessions, review history, and watch your interview skills improve over time.</p>
                    </div>
                    <div className="flex flex-col items-center gap-4">
                      <div className="flex gap-2">
                        <span className="w-2 h-2 rounded-full bg-white/60 border border-white/40" />
                        <span className="w-2 h-2 rounded-full bg-white/60 border border-white/40" />
                        <span className="w-6 h-2 rounded-full bg-indigo-650 shadow-sm shadow-indigo-600/30" />
                      </div>
                      <button 
                        onClick={() => setActiveScreen('register')}
                        className="w-full h-12 bg-indigo-600 hover:bg-indigo-750 text-white rounded-xl font-semibold flex items-center justify-center shadow-lg shadow-indigo-600/20 active:scale-95 duration-100 border border-indigo-550 cursor-pointer hover:shadow-indigo-600/35 hover:-translate-y-0.5 active:translate-y-0 transition-all duration-200"
                      >
                        Get Started
                      </button>
                    </div>
                  </div>
                )}

                {/* 5. LOGIN SCREEN STATE */}
                {activeScreen === 'login' && (
                  <div className="flex-1 flex flex-col justify-center p-5 bg-transparent backdrop-blur-md relative z-10 animate-fade-in">
                    <div className="text-center mb-6">
                      <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-indigo-600 to-purple-500 shadow-lg shadow-indigo-600/30 mb-4 mx-auto flex items-center justify-center border border-white/20 hover:scale-110 hover:-rotate-3 duration-300 transition-all">
                        <Sparkles className="w-7 h-7 text-white" />
                      </div>
                      <h2 className="text-2xl font-extrabold text-indigo-950 tracking-tight">Welcome Back</h2>
                      <p className="text-xs text-neutral-650 font-bold mt-1">Sign in to continue your interview prep.</p>
                    </div>
                    <form onSubmit={(e) => { e.preventDefault(); setActiveScreen('dashboard'); }} className="flex flex-col gap-4">
                      <div className="flex flex-col gap-1.5">
                        <label className="text-xs font-bold text-indigo-950 ml-1">Email Address</label>
                        <div className="relative">
                          <Mail className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-neutral-550" />
                          <input 
                            type="email" 
                            placeholder="you@example.com"
                            value={emailText}
                            onChange={(e) => setEmailText(e.target.value)}
                            className="w-full bg-white/45 border border-white/55 backdrop-blur-sm rounded-lg py-2.5 pl-10 pr-4 focus:bg-white/75 focus:outline-none focus:border-indigo-600 text-sm shadow-sm transition-all text-[#0b1c30] placeholder-neutral-500 font-medium"
                          />
                        </div>
                      </div>
                      <div className="flex flex-col gap-1.5">
                        <div className="flex justify-between items-center px-1">
                          <label className="text-xs font-bold text-indigo-950">Password</label>
                          <button type="button" onClick={() => setActiveScreen('forgot')} className="text-xs text-indigo-850 font-black hover:underline hover:scale-103 duration-150 transition-all">Forgot?</button>
                        </div>
                        <div className="relative">
                          <Lock className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-neutral-500" />
                          <input 
                            type={showPassword ? "text" : "password"} 
                            placeholder="••••••••"
                            value={passwordText}
                            onChange={(e) => setPasswordText(e.target.value)}
                            className="w-full bg-white/45 border border-white/55 backdrop-blur-sm rounded-lg py-2.5 pl-10 pr-10 focus:bg-white/75 focus:outline-none focus:border-indigo-600 text-sm shadow-sm transition-all text-[#0b1c30] font-medium"
                          />
                          <button 
                            type="button" 
                            onClick={() => setShowPassword(!showPassword)}
                            className="absolute right-3.5 top-1/2 -translate-y-1/2 text-neutral-500 hover:scale-110 active:scale-95 duration-100"
                          >
                            {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                          </button>
                        </div>
                      </div>
                      <button 
                        type="submit"
                        className="w-full h-12 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-xl flex items-center justify-center gap-2 shadow-lg shadow-indigo-600/20 mt-2 active:scale-95 hover:shadow-indigo-600/35 hover:-translate-y-0.5 active:translate-y-0 transition-all duration-200 border border-indigo-550 cursor-pointer"
                      >
                        Login <ArrowRight className="w-4 h-4" />
                      </button>
                    </form>
                    <p className="text-xs text-neutral-600 text-center mt-6 font-semibold">
                      Don't have an account? <button onClick={() => setActiveScreen('register')} className="text-indigo-850 font-black hover:underline cursor-pointer hover:scale-103 transition-all">Create account</button>
                    </p>
                  </div>
                )}

                {/* 6. REGISTER SCREEN STATE */}
                {activeScreen === 'register' && (
                  <div className="flex-1 flex flex-col justify-center p-5 bg-transparent backdrop-blur-md relative z-10 animate-fade-in">
                    <div className="text-center mb-6">
                      <div className="w-12 h-12 rounded-full bg-white/40 border border-white/50 shadow-md mb-3 mx-auto flex items-center justify-center hover:scale-110 hover:rotate-6 duration-300 transition-all">
                        <User className="w-6 h-6 text-indigo-700" />
                      </div>
                      <h2 className="text-2xl font-extrabold text-indigo-950 tracking-tight">Create Account</h2>
                      <p className="text-xs text-neutral-600 font-semibold mt-1">Join Interview Pro and start your journey.</p>
                    </div>
                    <div className="flex flex-col gap-3.5">
                      <div className="flex flex-col gap-1.5">
                        <label className="text-xs font-bold text-indigo-950 ml-1">Full Name</label>
                        <div className="relative">
                          <User className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-neutral-500" />
                          <input type="text" placeholder="e.g. Jane Doe" className="w-full bg-white/45 border border-white/55 backdrop-blur-sm rounded-lg py-2 pl-10 pr-4 text-xs focus:bg-white/75 focus:outline-none focus:border-indigo-600 text-[#0b1c30] placeholder-neutral-500 font-semibold shadow-sm transition-all" />
                        </div>
                      </div>
                      <div className="flex flex-col gap-1.5">
                        <label className="text-xs font-bold text-indigo-950 ml-1">Email Address</label>
                        <div className="relative">
                          <Mail className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-neutral-500" />
                          <input type="email" placeholder="name@example.com" className="w-full bg-white/45 border border-white/55 backdrop-blur-sm rounded-lg py-2 pl-10 pr-4 text-xs focus:bg-white/75 focus:outline-none focus:border-indigo-600 text-[#0b1c30] placeholder-neutral-500 font-semibold shadow-sm transition-all" />
                        </div>
                      </div>
                      <div className="flex flex-col gap-1.5">
                        <label className="text-xs font-bold text-indigo-950 ml-1">Password</label>
                        <div className="relative">
                          <Lock className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-neutral-500" />
                          <input type="password" placeholder="••••••••" className="w-full bg-white/45 border border-white/55 backdrop-blur-sm rounded-lg py-2 pl-10 pr-4 text-xs focus:bg-white/75 focus:outline-none focus:border-indigo-600 text-[#0b1c30] font-semibold" />
                        </div>
                      </div>
                      <button 
                        onClick={() => setActiveScreen('login')}
                        className="w-full h-11 bg-indigo-650 hover:bg-indigo-700 text-white rounded-xl font-semibold flex items-center justify-center gap-2 shadow-lg shadow-indigo-600/20 mt-2 active:scale-95 hover:shadow-indigo-600/35 hover:-translate-y-0.5 active:translate-y-0 transition-all duration-200 border border-indigo-550 cursor-pointer"
                      >
                        Sign Up <ArrowRight className="w-4 h-4" />
                      </button>
                    </div>
                    <p className="text-xs text-neutral-600 text-center mt-6 font-semibold">
                      Already have an account? <button onClick={() => setActiveScreen('login')} className="text-indigo-850 font-black hover:underline ml-1 cursor-pointer hover:scale-103 transition-all">Log in</button>
                    </p>
                  </div>
                )}

                {/* 7. FORGOT PASSWORD SCREEN STATE */}
                {activeScreen === 'forgot' && (
                  <div className="flex-1 flex flex-col justify-center p-6 bg-transparent backdrop-blur-md relative z-10 animate-fade-in text-center">
                    <div className="w-14 h-14 bg-white/40 border border-white/50 rounded-2xl flex items-center justify-center mb-4 mx-auto shadow-md hover:scale-110 hover:-rotate-6 transition-all duration-300">
                      <Lock className="w-7 h-7 text-indigo-600" />
                    </div>
                    <h2 className="text-2xl font-bold text-indigo-950 tracking-tight">Forgot Password?</h2>
                    <p className="text-xs text-neutral-600 mt-2 max-w-[240px] mx-auto font-semibold leading-relaxed">
                      Enter your email address and we'll send you instructions to reset your password.
                    </p>
                    <div className="w-full text-left mt-6 flex flex-col gap-4">
                      <div className="flex flex-col gap-1.5">
                        <label className="text-xs font-bold text-indigo-950 ml-1">Email Address</label>
                        <div className="relative">
                          <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-neutral-500" />
                          <input type="email" placeholder="you@example.com" className="w-full bg-white/45 border border-white/55 backdrop-blur-sm rounded-lg py-2 pl-10 pr-4 text-sm focus:bg-white/75 focus:outline-none text-[#0b1c30] placeholder-neutral-500 font-semibold" />
                        </div>
                      </div>
                      <button 
                        onClick={() => setActiveScreen('login')}
                        className="w-full h-11 bg-indigo-650 hover:bg-indigo-700 text-white font-semibold rounded-lg shadow-lg border border-indigo-550 active:scale-95 hover:shadow-indigo-600/35 hover:-translate-y-0.5 active:translate-y-0 transition-all duration-200 cursor-pointer"
                      >
                        Reset Password
                      </button>
                    </div>
                    <button 
                      onClick={() => setActiveScreen('login')}
                      className="mt-6 text-xs text-indigo-700 font-extrabold hover:underline inline-flex items-center gap-1 group justify-center mx-auto bg-white/35 px-4 py-1.5 border border-white/40 rounded-full hover:scale-105 active:scale-95 duration-150 transition-all"
                    >
                      <ArrowLeft className="w-3.5 h-3.5 group-hover:-translate-x-1 transition-transform" /> Back to Login
                    </button>
                  </div>
                )}

                {/* 8. HOME DASHBOARD SCREEN STATE */}
                {activeScreen === 'dashboard' && (
                  <div className="flex-1 flex flex-col justify-between bg-transparent backdrop-blur-md animate-fade-in relative z-10">
                    <div className="p-4 flex flex-col gap-5">
                      <div>
                        <h2 className="text-3xl font-extrabold text-indigo-950 tracking-tight">Hi, Alex</h2>
                        <p className="text-xs text-neutral-600 font-semibold">Ready to ace your next interview?</p>
                      </div>

                      {/* Bento Cards Row */}
                      <div className="grid grid-cols-2 gap-3">
                        <div className="bg-white/45 border border-white/55 rounded-2xl p-4 shadow-sm flex flex-col justify-between h-[100px] hover:scale-[1.03] hover:-translate-y-0.5 hover:shadow-md hover:bg-white/55 transition-all duration-200 cursor-pointer">
                          <div className="flex items-center gap-2 text-indigo-950">
                            <PieChart className="w-4 h-4 text-purple-600" />
                            <span className="text-[10px] font-bold uppercase tracking-wider">Total</span>
                          </div>
                          <span className="text-2xl font-black text-indigo-950 leading-none">12</span>
                        </div>
                        <div className="bg-white/45 border border-white/55 rounded-2xl p-4 shadow-sm flex flex-col justify-between h-[100px] hover:scale-[1.03] hover:-translate-y-0.5 hover:shadow-md hover:bg-white/55 transition-all duration-200 cursor-pointer">
                          <div className="flex items-center gap-2 text-indigo-950">
                            <Award className="w-4 h-4 text-indigo-600" />
                            <span className="text-[10px] font-bold uppercase tracking-wider">Avg Score</span>
                          </div>
                          <span className="text-2xl font-black text-indigo-650 leading-none">85%</span>
                        </div>
                      </div>

                      {/* Dynamic Action rows */}
                      <div className="flex flex-col gap-3">
                        <button 
                          onClick={() => setActiveScreen('category')}
                          className="w-full bg-gradient-to-r from-indigo-600 to-indigo-700 hover:from-indigo-650 hover:to-indigo-750 text-white rounded-2xl p-4 shadow-lg hover:shadow-indigo-600/25 border border-indigo-500/20 flex items-center justify-between group hover:-translate-y-0.5 active:translate-y-0 active:scale-95 transition-all duration-200 text-left cursor-pointer"
                        >
                          <div className="flex items-center gap-3">
                            <div className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center backdrop-blur-sm group-hover:scale-105 duration-200">
                              <Play className="w-5 h-5 fill-white text-white" />
                            </div>
                            <div>
                              <h3 className="text-sm font-bold">Start New Practice</h3>
                              <p className="text-[10px] text-indigo-150 mt-0.5">Begin an AI mock interview session</p>
                            </div>
                          </div>
                          <ChevronRight className="w-5 h-5 text-indigo-200 group-hover:translate-x-1 duration-150" />
                        </button>

                        <button 
                          onClick={() => setActiveScreen('history')}
                          className="w-full bg-white/45 hover:bg-white/55 text-indigo-950 rounded-2xl p-4 shadow-sm hover:shadow-md border border-white/55 flex items-center justify-between text-left hover:scale-[1.01] hover:-translate-y-0.5 active:translate-y-0 active:scale-99 transition-all duration-200 cursor-pointer"
                        >
                          <div className="flex items-center gap-3">
                            <div className="w-10 h-10 bg-white/40 border border-white/50 rounded-full flex items-center justify-center">
                              <History className="w-5 h-5 text-neutral-600" />
                            </div>
                            <div>
                              <h3 className="text-sm font-bold">View History</h3>
                              <p className="text-[10px] text-neutral-600 font-semibold mt-0.5">Review past sessions and feedback</p>
                            </div>
                          </div>
                          <ChevronRight className="w-5 h-5 text-neutral-500 hover:translate-x-0.5 transition-transform" />
                        </button>

                        <button 
                          onClick={() => setActiveScreen('profile')}
                          className="w-full bg-white/45 hover:bg-white/55 text-indigo-950 rounded-2xl p-4 shadow-sm hover:shadow-md border border-white/55 flex items-center justify-between text-left hover:scale-[1.01] hover:-translate-y-0.5 active:translate-y-0 active:scale-99 transition-all duration-200 cursor-pointer"
                        >
                          <div className="flex items-center gap-3">
                            <div className="w-10 h-10 bg-white/40 border border-white/50 rounded-full flex items-center justify-center">
                              <User className="w-5 h-5 text-neutral-600" />
                            </div>
                            <div>
                              <h3 className="text-sm font-bold">Profile Settings</h3>
                              <p className="text-[10px] text-neutral-600 font-semibold mt-0.5">Manage details and daily streaks</p>
                            </div>
                          </div>
                          <ChevronRight className="w-5 h-5 text-neutral-500 hover:translate-x-0.5 transition-transform" />
                        </button>
                      </div>
                    </div>

                    {/* Dashboard bottom menu bar mockup */}
                    <div className="bg-white/40 backdrop-blur-md border-t border-white/50 px-4 py-2 flex items-center justify-between shrink-0 relative z-20">
                      <button className="flex flex-col items-center justify-center bg-white/60 border border-white/70 text-indigo-700 rounded-xl px-3 py-1 scale-95 duration-100 font-bold shadow-sm cursor-pointer">
                        <Smartphone className="w-5 h-5 text-indigo-750" />
                        <span className="text-[8px] font-bold mt-1">Home</span>
                      </button>
                      <button onClick={() => setActiveScreen('history')} className="flex flex-col items-center justify-center text-neutral-600 hover:text-indigo-900 px-3 py-1 cursor-pointer font-bold duration-100">
                        <History className="w-5 h-5" />
                        <span className="text-[8px] mt-1">History</span>
                      </button>
                      <button onClick={() => setActiveScreen('profile')} className="flex flex-col items-center justify-center text-neutral-600 hover:text-indigo-900 px-3 py-1 cursor-pointer font-bold duration-100">
                        <User className="w-5 h-5" />
                        <span className="text-[8px] mt-1">Profile</span>
                      </button>
                    </div>
                  </div>
                )}

                {/* 9. CHOOSE CATEGORY SCREEN STATE */}
                {activeScreen === 'category' && (
                  <div className="flex-1 flex flex-col p-4 bg-transparent backdrop-blur-md animate-fade-in justify-between relative z-10">
                    <div>
                      <h2 className="text-2xl font-extrabold text-indigo-950 tracking-tight">Choose a Category</h2>
                      <p className="text-xs text-neutral-600 font-semibold mt-1 leading-snug">Select a domain to begin your tailored interview practice.</p>
 
                      <div className="grid grid-cols-2 gap-3 mt-6">
                        <button 
                          onClick={() => setActiveScreen('practice')}
                          className="flex flex-col items-stretch p-4 bg-white/45 hover:bg-white/55 rounded-xl shadow-sm border border-white/55 hover:shadow-md border-t-2 border-t-indigo-600 text-left relative hover:scale-[1.03] hover:-translate-y-0.5 active:translate-y-0 active:scale-98 transition-all duration-200 cursor-pointer"
                        >
                          <div className="w-10 h-10 rounded-full bg-white/50 border border-white/60 flex items-center justify-center text-indigo-600 mb-4 duration-250 group-hover:scale-105">
                            <User className="w-5 h-5" />
                          </div>
                          <h3 className="text-xs font-extrabold text-indigo-950">HR Interview</h3>
                          <p className="text-[9px] text-neutral-500 font-semibold mt-1">Behavioral &amp; Fit</p>
                        </button>
 
                        <button 
                          onClick={() => setActiveScreen('practice')}
                          className="flex flex-col items-stretch p-4 bg-white/45 hover:bg-white/55 rounded-xl shadow-sm border border-white/55 hover:shadow-md border-t-2 border-t-indigo-600 text-left relative hover:scale-[1.03] hover:-translate-y-0.5 active:translate-y-0 active:scale-98 transition-all duration-200 cursor-pointer"
                        >
                          <div className="w-10 h-10 rounded-full bg-white/50 border border-white/60 flex items-center justify-center text-indigo-600 mb-4 duration-250 group-hover:scale-105">
                            <Code className="w-5 h-5" />
                          </div>
                          <h3 className="text-xs font-extrabold text-indigo-950">Software Eng.</h3>
                          <p className="text-[9px] text-neutral-500 font-semibold mt-1">Algorithms &amp; Systems</p>
                        </button>
 
                        <button 
                          onClick={() => setActiveScreen('practice')}
                          className="flex flex-col items-stretch p-4 bg-white/45 hover:bg-white/55 rounded-xl shadow-sm border border-white/55 hover:shadow-md border-t-2 border-t-indigo-600 text-left relative hover:scale-[1.03] hover:-translate-y-0.5 active:translate-y-0 active:scale-98 transition-all duration-200 cursor-pointer"
                        >
                          <div className="w-10 h-10 rounded-full bg-white/50 border border-white/60 flex items-center justify-center text-indigo-600 mb-4 duration-250 group-hover:scale-105">
                            <Sparkles className="w-5 h-5" />
                          </div>
                          <h3 className="text-xs font-extrabold text-indigo-950">AI / ML</h3>
                          <p className="text-[9px] text-neutral-500 font-semibold mt-1">Models &amp; Data</p>
                        </button>
 
                        <button 
                          onClick={() => setActiveScreen('practice')}
                          className="flex flex-col items-stretch p-4 bg-white/45 hover:bg-white/55 rounded-xl shadow-sm border border-white/55 hover:shadow-md border-t-2 border-t-indigo-600 text-left relative hover:scale-[1.03] hover:-translate-y-0.5 active:translate-y-0 active:scale-98 transition-all duration-200 cursor-pointer"
                        >
                          <div className="w-10 h-10 rounded-full bg-white/50 border border-white/60 flex items-center justify-center text-indigo-600 mb-4 duration-250 group-hover:scale-105">
                            <Grid className="w-5 h-5" />
                          </div>
                          <h3 className="text-xs font-extrabold text-indigo-950">Data Science</h3>
                          <p className="text-[9px] text-neutral-500 font-semibold mt-1">Stats &amp; Analysis</p>
                        </button>
                      </div>
                    </div>
                  </div>
                )}
 
                {/* 10. PRACTICE QUESTION SCREEN STATE */}
                {activeScreen === 'practice' && (
                  <div className="flex-1 flex flex-col p-4 bg-transparent backdrop-blur-md animate-fade-in justify-between relative z-10">
                    <div className="flex flex-col gap-4">
                      {/* Sub-badge header */}
                      <div className="flex items-center justify-between">
                        <span className="bg-white/45 border border-white/55 text-indigo-950 text-[10px] font-extrabold px-3 py-1 rounded-full flex items-center gap-1.5 shadow-sm hover:scale-103 transition-all">
                          <User className="w-3.5 h-3.5 text-indigo-600" /> HR Interview
                        </span>
                        <span className="text-[10px] text-indigo-950/80 font-bold">1 of 5</span>
                      </div>
 
                      {/* Question Content Box split with indigo leading stripe */}
                      <div className="bg-white/45 backdrop-blur-sm rounded-2xl p-4 border border-white/55 border-l-4 border-l-indigo-600 shadow-sm relative hover:shadow-md transition-all duration-300">
                        <h3 className="font-extrabold text-indigo-950 text-lg leading-tight">Tell me about yourself.</h3>
                        <p className="text-xs text-neutral-600 font-semibold mt-2 leading-relaxed">
                          Provide a brief overview of your professional background, key skills, and what brings you to this interview today. Keep it concise.
                        </p>
                        <div className="mt-4 flex justify-end">
                          <button onClick={() => setShowHint(!showHint)} className="text-indigo-800 font-black text-xs flex items-center gap-1.5 focus:outline-none cursor-pointer hover:scale-105 active:scale-95 duration-100 transition-all">
                            <Lightbulb className="w-4 h-4 text-indigo-650" /> Hint
                          </button>
                        </div>
 
                        {showHint && (
                          <div className="mt-3 p-3 bg-white/55 border border-indigo-100 rounded-xl text-[10px] text-indigo-900 font-bold animate-fade-in flex items-center gap-1.5 shadow-sm">
                            <span>💡</span> <span>Use the <strong className="text-indigo-800">STAR</strong> method to map your answer timeline elegantly.</span>
                          </div>
                        )}
                      </div>
 
                      {/* Text response input space */}
                      <div className="flex flex-col gap-1.5 relative">
                        <div className="flex justify-between items-center px-1">
                          <span className="text-xs font-bold text-indigo-950">Your Response</span>
                          {speechFeedback && (
                            <span className="text-[10px] bg-rose-50 text-rose-600 px-2 py-0.5 rounded-full border border-rose-100 font-bold animate-pulse">
                              {speechFeedback}
                            </span>
                          )}
                        </div>
                        <div className="relative">
                          <textarea 
                            value={responseInputText}
                            onChange={(e) => setResponseInputText(e.target.value)}
                            placeholder="Type your answer here or use the voice input..."
                            rows={5}
                            className="w-full bg-white/45 border border-white/55 backdrop-blur-sm rounded-xl p-3.5 pr-14 text-xs text-[#0b1c30] placeholder-neutral-500 font-semibold focus:bg-white/75 focus:outline-none focus:border-indigo-600 shadow-sm resize-none transition-all"
                          />
                          {/* Floating voice mic mockup */}
                          <button 
                            type="button"
                            onClick={toggleSpeechRecognition}
                            className={`absolute bottom-3 right-3 w-10 h-10 rounded-full flex items-center justify-center transition-all duration-200 shadow-sm cursor-pointer ${
                              isListening 
                                ? 'bg-rose-500 text-white hover:bg-rose-600 scale-110 animate-pulse border-none ring-4 ring-rose-300' 
                                : 'bg-white/60 hover:bg-white/85 hover:scale-105 border border-white/75 text-indigo-700 active:scale-90 duration-150'
                            }`}
                            title={isListening ? 'Stop dictating voice input' : 'Start voice dictation / input'}
                          >
                            <Mic className={`w-4 h-4 ${isListening ? 'text-white' : 'text-indigo-700'}`} />
                          </button>
                        </div>
                      </div>
                    </div>
 
                    <button 
                      onClick={() => setActiveScreen('feedback')}
                      className="w-full h-12 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-xl flex items-center justify-center gap-2 shadow-lg shadow-indigo-600/20 mt-4 active:scale-95 hover:shadow-indigo-600/35 hover:-translate-y-0.5 active:translate-y-0 transition-all duration-200 border border-indigo-550 cursor-pointer"
                    >
                      Submit Answer <Send className="w-4 h-4 text-white" />
                    </button>
                  </div>
                )}

                {/* 11. FEEDBACK SCORE CARD STATE */}
                {activeScreen === 'feedback' && (
                  <div className="flex-1 flex flex-col p-4 bg-transparent backdrop-blur-md animate-fade-in overflow-y-auto hide-scrollbar gap-5 relative z-10">
                    {/* Ring Display */}
                    <div className="flex flex-col items-center text-center mt-2 group cursor-pointer">
                      <div className="relative w-36 h-36 flex items-center justify-center bg-white/45 backdrop-blur-sm border border-white/55 rounded-full p-2 shadow-sm hover:scale-105 duration-350 transition-all">
                        <svg className="absolute inset-0 w-full h-full transform -rotate-90 p-1.5" viewBox="0 0 100 100">
                          <circle cx="50" cy="50" r="42" fill="none" stroke="#e2dfff" strokeWidth="6" />
                          <circle cx="50" cy="50" r="42" fill="none" stroke="#712ae2" strokeWidth="6" strokeDasharray="263" strokeDashoffset="31" />
                        </svg>
                        <div className="flex flex-col items-center z-10">
                          <span className="text-3xl font-black text-indigo-950 leading-none">88<span className="text-xs text-neutral-500">/100</span></span>
                          <span className="text-xs text-indigo-800 font-extrabold mt-1 group-hover:scale-110 duration-200 transition-transform">Excellent</span>
                        </div>
                      </div>
                      <h3 className="text-lg font-bold text-indigo-950 mt-4">Great Job!</h3>
                      <p className="text-xs text-neutral-600 font-semibold mt-1 max-w-[240px]">Your response was strong and highly structured. Minor tweaks make you perfect!</p>
                    </div>

                    {/* Cards analysis details */}
                    <div className="bg-white/45 backdrop-blur-sm rounded-2xl p-4 border border-white/55 border-l-4 border-l-indigo-600 shadow-sm relative overflow-hidden hover:scale-[1.01] hover:shadow-md transition-all duration-300">
                      <h4 className="font-extrabold text-sm text-indigo-950 flex items-center gap-1.5 mb-2">
                        <Sparkles className="w-4 h-4 text-indigo-700 animate-pulse" /> Detailed Feedback
                      </h4>
                      <p className="text-[11px] text-neutral-600 font-semibold leading-relaxed">
                        Successfully used STAR. The Situation / Task description is extremely crisp. Improvements on the metrics would elevate further.
                      </p>
                      
                      <div className="mt-4 grid grid-cols-2 gap-3 border-t border-white/45 pt-3">
                        <div className="hover:scale-103 duration-150 transition-transform">
                          <span className="text-[10px] font-extrabold text-indigo-800 flex items-center gap-1 mb-1.5">
                            <CheckCircle className="w-3.5 h-3.5 text-indigo-600" /> Strengths
                          </span>
                          <ul className="text-[9px] text-neutral-600 font-semibold space-y-1">
                            <li>• Clear flow.</li>
                            <li>• STAR mapped.</li>
                          </ul>
                        </div>
                        <div className="hover:scale-103 duration-150 transition-transform">
                          <span className="text-[10px] font-extrabold text-rose-800 flex items-center gap-1 mb-1.5">
                            <AlertTriangle className="w-3.5 h-3.5 text-rose-600" /> Improve
                          </span>
                          <ul className="text-[9px] text-neutral-600 font-semibold space-y-1">
                            <li>• Quantify metrics.</li>
                          </ul>
                        </div>
                      </div>
                    </div>

                    <div className="flex flex-col gap-2 shrink-0">
                      <button onClick={() => { setActiveScreen('dashboard'); }} className="w-full h-11 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-bold text-xs flex items-center justify-center gap-2 border border-indigo-550 shadow-md hover:shadow-indigo-650/35 hover:-translate-y-0.5 active:translate-y-0 active:scale-95 duration-205 transition-all cursor-pointer">
                        <Bookmark className="w-4 h-4" /> Save Results
                      </button>
                      <button onClick={() => { setActiveScreen('practice'); }} className="w-full h-11 border border-white/60 bg-white/40 hover:bg-white/50 hover:border-white/70 text-indigo-800 rounded-xl font-black text-xs cursor-pointer active:scale-95 duration-100 transition-all">
                        Practice Again
                      </button>
                    </div>
                  </div>
                )}

                {/* 12. HISTORIC DETAIL EVALUATION VIEW */}
                {activeScreen === 'details' && (
                  <div className="flex-1 flex flex-col p-4 bg-transparent backdrop-blur-md animate-fade-in overflow-y-auto gap-4 relative z-10">
                    {/* Overall score banner card */}
                    <div className="bg-white/45 backdrop-blur-sm rounded-2xl p-4 border border-white/55 shadow-sm relative overflow-hidden flex justify-between items-center border-l-4 border-l-indigo-600 hover:scale-[1.01] hover:shadow-md transition-all duration-200">
                      <div>
                        <h3 className="font-bold text-sm text-indigo-950">Overall Score</h3>
                        <p className="text-[9px] text-neutral-500 font-bold mt-0.5">Behavioral Interview - Oct 12</p>
                      </div>
                      <div className="relative w-11 h-11 flex items-center justify-center bg-white/50 border border-white/60 rounded-full hover:scale-105 transition-transform duration-200">
                        <div className="absolute inset-0 rounded-full border-2 border-purple-100" />
                        <span className="text-xs font-black text-purple-700">85</span>
                      </div>
                    </div>

                    {/* Question text box */}
                    <div className="bg-white/45 backdrop-blur-sm rounded-xl p-4 border border-white/55 shadow-sm hover:scale-[1.01] hover:shadow-md transition-all duration-200">
                      <span className="text-[9px] font-black text-indigo-700 tracking-wider">THE QUESTION</span>
                      <p className="text-xs text-indigo-950 font-bold mt-1 leading-snug">
                        "Tell me about a time you had to manage conflicting priorities. How did you resolve them?"
                      </p>
                    </div>

                    {/* Your response with custom played duration */}
                    <div className="bg-white/45 backdrop-blur-sm rounded-xl p-4 border border-white/55 shadow-sm flex flex-col gap-3 hover:scale-[1.01] hover:shadow-md transition-all duration-200">
                      <span className="text-[9px] font-extrabold text-neutral-500 tracking-wider">YOUR RESPONSE</span>
                      <p className="text-[11px] text-neutral-600 font-semibold leading-relaxed italic">
                        "In my last role, we were launching the app while simultaneously having to fix server memory bugs. I proposed a split timeline that mapped the tasks precisely..."
                      </p>
                      
                      {/* Audio block simulator */}
                      <div className="bg-white/30 backdrop-blur-sm rounded-xl p-3 border border-white/45 flex items-center gap-3">
                        <button 
                          onClick={() => setIsPlayingAudio(!isPlayingAudio)}
                          className="w-8 h-8 rounded-full bg-indigo-650 hover:bg-indigo-700 text-white flex items-center justify-center active:scale-90 hover:scale-105 duration-150 cursor-pointer shadow-sm transition-all"
                        >
                          <Play className="w-4 h-4 text-white fill-white ml-0.5" />
                        </button>
                        <div className="flex-1 bg-white/50 h-1 rounded-full relative border border-white/20">
                          <div className="bg-indigo-600 h-1 rounded-full transition-all duration-300" style={{ width: `${audioProgress}%` }} />
                        </div>
                        <span className="text-[10px] text-indigo-950 font-bold">01:45</span>
                      </div>
                    </div>
                  </div>
                )}

                {/* 13. SESSION PASTS LIST HISTORY */}
                {activeScreen === 'history' && (
                  <div className="flex-1 flex flex-col justify-between bg-transparent backdrop-blur-md animate-fade-in relative z-10">
                    <div className="p-4 flex flex-col gap-4">
                      <div>
                        <h2 className="text-2xl font-extrabold text-indigo-950 tracking-tight">History</h2>
                        <p className="text-xs text-neutral-600 font-semibold">Review your past sessions and track progress.</p>
                      </div>

                      {/* Mock list items */}
                      <div className="flex flex-col gap-3">
                        <button 
                          onClick={() => setActiveScreen('details')}
                          className="w-full text-left bg-white/45 hover:bg-white/55 rounded-2xl p-4 shadow-sm border border-white/55 border-l-4 border-l-indigo-600 hover:scale-[1.01] hover:-translate-y-0.5 hover:shadow-md active:translate-y-0 active:scale-99 transition-all duration-200 flex items-center justify-between cursor-pointer"
                        >
                          <div>
                            <span className="text-[9px] text-neutral-500 font-semibold">Oct 24, 2026 • 10:30 AM</span>
                            <h3 className="font-bold text-xs text-indigo-950 mt-1">Software Engineering</h3>
                            <span className="text-[9px] font-bold bg-indigo-50/65 text-indigo-700 px-2 py-0.5 rounded-full inline-block mt-1.5 border border-indigo-100/30 hover:scale-103 duration-150 transition-all">Score: 85/100</span>
                          </div>
                          <ChevronRight className="w-4 h-4 text-indigo-600 transition-transform group-hover:translate-x-0.5" />
                        </button>

                        <button 
                          onClick={() => setActiveScreen('details')}
                          className="w-full text-left bg-white/45 hover:bg-white/55 rounded-2xl p-4 shadow-sm border border-white/55 border-l-4 border-l-purple-600 hover:scale-[1.01] hover:-translate-y-0.5 hover:shadow-md active:translate-y-0 active:scale-99 transition-all duration-200 flex items-center justify-between cursor-pointer"
                        >
                          <div>
                            <span className="text-[9px] text-neutral-500 font-semibold">Oct 20, 2026 • 2:15 PM</span>
                            <h3 className="font-bold text-xs text-indigo-950 mt-1">Behavioral - Leadership</h3>
                            <span className="text-[9px] font-bold bg-purple-50/65 text-purple-700 px-2 py-0.5 rounded-full inline-block mt-1.5 border border-purple-100/30 hover:scale-103 duration-150 transition-all">Score: 92/100</span>
                          </div>
                          <ChevronRight className="w-4 h-4 text-purple-600 transition-transform group-hover:translate-x-0.5" />
                        </button>

                        <button 
                          onClick={() => setActiveScreen('details')}
                          className="w-full text-left bg-white/45 hover:bg-white/55 rounded-2xl p-4 shadow-sm border border-white/55 border-l-4 border-l-slate-400 hover:scale-[1.01] hover:-translate-y-0.5 hover:shadow-md active:translate-y-0 active:scale-99 transition-all duration-200 flex items-center justify-between cursor-pointer"
                        >
                          <div>
                            <span className="text-[9px] text-neutral-500 font-semibold">Oct 15, 2026 • 9:00 AM</span>
                            <h3 className="font-bold text-xs text-indigo-950 mt-1">System Design</h3>
                            <span className="text-[9px] font-bold bg-slate-100/65 text-slate-800 px-2 py-0.5 rounded-full inline-block mt-1.5 border border-slate-200/30 hover:scale-103 duration-150 transition-all">Score: 78/100</span>
                          </div>
                          <ChevronRight className="w-4 h-4 text-slate-500 transition-transform group-hover:translate-x-0.5" />
                        </button>
                      </div>
                    </div>

                    {/* Bottom menu bar mockup */}
                    <div className="bg-white/40 backdrop-blur-md border-t border-white/50 px-4 py-2 flex items-center justify-between shrink-0 relative z-20">
                      <button onClick={() => setActiveScreen('dashboard')} className="flex flex-col items-center justify-center text-neutral-600 hover:text-indigo-900 px-3 py-1 cursor-pointer font-bold duration-100">
                        <Smartphone className="w-5 h-5" />
                        <span className="text-[8px] mt-1">Home</span>
                      </button>
                      <button className="flex flex-col items-center justify-center bg-white/60 border border-white/70 text-indigo-700 rounded-xl px-3 py-1 scale-95 duration-100 font-bold shadow-sm cursor-pointer">
                        <History className="w-5 h-5 text-indigo-750" />
                        <span className="text-[8px] font-bold mt-1">History</span>
                      </button>
                      <button onClick={() => setActiveScreen('profile')} className="flex flex-col items-center justify-center text-neutral-600 hover:text-indigo-900 px-3 py-1 cursor-pointer font-bold duration-100">
                        <User className="w-5 h-5" />
                        <span className="text-[8px] mt-1">Profile</span>
                      </button>
                    </div>
                  </div>
                )}

                {/* 14. PROFILE SCREEN STATE */}
                {activeScreen === 'profile' && (
                  <div className="flex-1 flex flex-col justify-between bg-transparent backdrop-blur-md animate-fade-in relative z-10 text-indigo-950">
                    {isEditingProfile ? (
                      /* PROFILE EDITOR SCREEN */
                      <div className="flex-1 flex flex-col min-h-0 bg-transparent">
                        {/* Header banner */}
                        <div className="p-3 bg-white/45 backdrop-blur-sm border-b border-white/55 flex items-center justify-between shrink-0">
                          <span className="text-xs font-black text-indigo-950">Edit Account</span>
                          <div className="flex items-center gap-1.5">
                            <button 
                              type="button"
                              onClick={() => setIsEditingProfile(false)} 
                              className="text-[10px] font-bold text-neutral-600 hover:text-neutral-700 bg-white/40 border border-white/50 px-2 py-1 rounded-md cursor-pointer"
                            >
                              Cancel
                            </button>
                            <button 
                              type="button"
                              onClick={handleSaveProfile} 
                              className="text-[10px] font-bold text-white bg-indigo-650 hover:bg-indigo-700 px-2 py-1 rounded-md flex items-center gap-1 shadow-sm cursor-pointer"
                            >
                              <Check className="w-3 h-3 text-white" /> Save
                            </button>
                          </div>
                        </div>

                        {/* Interactive Form fields scrollable */}
                        <div className="flex-1 p-4 overflow-y-auto hide-scrollbar flex flex-col gap-3.5 pb-20">
                          
                          {/* Image choice section */}
                          <div className="flex flex-col items-center">
                            <div className="relative">
                              <div className="w-16 h-16 rounded-full border-2 border-white/70 shadow-md overflow-hidden relative">
                                <img src={editingPhoto} className="w-full h-full object-cover" />
                              </div>
                              <span className="absolute -bottom-1 -right-1 bg-indigo-600 text-white rounded-full p-1 border border-white shadow-sm flex items-center justify-center">
                                <Camera className="w-3 h-3 text-white" />
                              </span>
                            </div>
                            
                            {/* Preset Avatars picker */}
                            <div className="mt-2.5 w-full">
                              <span className="text-[10px] font-extrabold text-indigo-950 tracking-wide uppercase block text-center mb-1.5">Preset Profile Images:</span>
                              <div className="flex items-center justify-center gap-2">
                                {[
                                  { gender: 'F1', url: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200' },
                                  { gender: 'M1', url: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200' },
                                  { gender: 'F2', url: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200' },
                                  { gender: 'M2', url: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200' },
                                  { gender: 'F3', url: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=200' }
                                ].map((av, index) => (
                                  <button
                                    key={index}
                                    type="button"
                                    onClick={() => setEditingPhoto(av.url)}
                                    className={`w-9 h-9 rounded-full overflow-hidden border-2 cursor-pointer transition-all ${
                                      editingPhoto === av.url ? 'border-indigo-600 scale-110 shadow-md' : 'border-white/50 opacity-80 hover:opacity-100 hover:scale-105'
                                    }`}
                                  >
                                    <img src={av.url} className="w-full h-full object-cover animate-fade-in" />
                                  </button>
                                ))}
                              </div>

                              <div className="mt-2 text-left">
                                <span className="text-[9px] font-bold text-neutral-500 block mb-0.5">Or enter custom web URL:</span>
                                <input 
                                  type="text"
                                  value={editingPhoto}
                                  onChange={(e) => setEditingPhoto(e.target.value)}
                                  placeholder="https://example.com/photo.jpg"
                                  className="w-full bg-white/45 border border-white/55 rounded-lg px-2.5 py-1 text-[11px] text-[#0b1c30] placeholder-neutral-400 font-semibold focus:bg-white/75 focus:outline-none focus:border-indigo-600"
                                />
                              </div>
                            </div>
                          </div>

                          {/* Inputs */}
                          <div className="flex flex-col gap-2.5 text-left">
                            <div>
                              <label className="text-[9px] font-extrabold text-indigo-950 uppercase tracking-wider block mb-0.5">Full Name</label>
                              <input 
                                type="text"
                                value={editingName}
                                onChange={(e) => setEditingName(e.target.value)}
                                className="w-full bg-white/45 border border-white/55 rounded-lg px-2.5 py-1 text-xs text-[#0b1c30] font-bold focus:bg-white/75 focus:outline-none focus:border-indigo-600 shadow-sm"
                              />
                            </div>

                            <div>
                              <label className="text-[9px] font-extrabold text-[#111e38] uppercase tracking-wider block mb-0.5">Email Address</label>
                              <input 
                                type="email"
                                value={editingEmail}
                                onChange={(e) => setEditingEmail(e.target.value)}
                                className="w-full bg-white/45 border border-white/55 rounded-lg px-2.5 py-1 text-xs text-[#0b1c30] font-bold focus:bg-white/75 focus:outline-none focus:border-indigo-600 shadow-sm"
                              />
                            </div>

                            <div>
                              <label className="text-[9px] font-extrabold text-indigo-950 uppercase tracking-wider block mb-0.5">Professional Title</label>
                              <input 
                                type="text"
                                value={editingTitle}
                                onChange={(e) => setEditingTitle(e.target.value)}
                                className="w-full bg-white/45 border border-white/55 rounded-lg px-2.5 py-1 text-xs text-[#0b1c30] font-bold focus:bg-white/75 focus:outline-none focus:border-indigo-600 shadow-sm"
                              />
                            </div>

                            <div>
                              <label className="text-[9px] font-extrabold text-indigo-950 uppercase tracking-wider block mb-0.5">Phone Number</label>
                              <input 
                                type="text"
                                value={editingPhone}
                                onChange={(e) => setEditingPhone(e.target.value)}
                                className="w-full bg-white/45 border border-white/55 rounded-lg px-2.5 py-1 text-xs text-[#0b1c30] font-bold focus:bg-white/75 focus:outline-none focus:border-indigo-600 shadow-sm"
                              />
                            </div>

                            <div>
                              <label className="text-[9px] font-extrabold text-indigo-950 uppercase tracking-wider block mb-0.5">Professional Bio Summary</label>
                              <textarea 
                                value={editingBio}
                                rows={2}
                                onChange={(e) => setEditingBio(e.target.value)}
                                className="w-full bg-white/45 border border-white/55 rounded-lg p-2 text-xs text-[#0b1c30] font-semibold focus:bg-white/75 focus:outline-none focus:border-indigo-600 shadow-sm resize-none"
                              />
                            </div>
                          </div>

                          <div className="flex flex-col gap-1.5 shrink-0 mt-2">
                            <button 
                              type="button"
                              onClick={handleSaveProfile} 
                              className="w-full h-9 bg-indigo-650 hover:bg-indigo-700 text-white rounded-lg font-bold text-xs flex items-center justify-center gap-1 shadow-sm cursor-pointer border border-indigo-550 active:scale-97 duration-100 transition-all text-center"
                            >
                              <Check className="w-3.5 h-3.5 text-white" /> Save Profile Details
                            </button>
                            <button 
                              type="button"
                              onClick={() => setIsEditingProfile(false)} 
                              className="w-full h-9 border border-white/60 bg-white/40 hover:bg-white/50 text-indigo-800 rounded-lg font-black text-xs cursor-pointer active:scale-97 duration-100 transition-all text-center"
                            >
                              Cancel Edits
                            </button>
                          </div>

                        </div>
                      </div>
                    ) : (
                      /* STATIC PROFILE VIEW */
                      <div className="p-4 flex flex-col gap-4 overflow-y-auto scrollbar-none flex-1">
                        {/* Avatar specs */}
                        <div className="flex flex-col items-center text-center py-1 relative">
                          <button 
                            type="button"
                            onClick={handleStartEditing} 
                            className="absolute top-0 right-0 w-7 h-7 rounded-full bg-white/50 hover:bg-white/80 active:scale-95 transition-all flex items-center justify-center text-indigo-700 shadow-sm border border-white/65 cursor-pointer"
                            title="Edit Profile"
                          >
                            <Edit2 className="w-3.5 h-3.5 text-indigo-700" />
                          </button>
                          <div className="w-20 h-20 rounded-full border-4 border-white/70 shadow-md relative group overflow-hidden mb-3">
                            <img src={profilePhoto} className="w-full h-full object-cover" />
                            <div className="absolute inset-0 bg-black/40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-200">
                              <button type="button" onClick={handleStartEditing} className="text-white text-xs font-bold flex items-center gap-1 cursor-pointer">
                                <Camera className="w-3.5 h-3.5" /> Edit
                              </button>
                            </div>
                          </div>
                          <h3 className="font-extrabold text-sm text-indigo-950 leading-none">{profileName}</h3>
                          <span className="text-[9px] bg-indigo-50/70 text-indigo-800 px-2.5 py-0.5 rounded-full border border-indigo-100/50 font-extrabold tracking-tight mt-1.5">
                            {profileTitle}
                          </span>
                          <p className="text-[10px] text-neutral-600 font-semibold mt-1">{profileEmail}</p>
                        </div>

                        {/* Stat summary grid */}
                        <div className="grid grid-cols-2 gap-3">
                          <div className="bg-white/45 backdrop-blur-sm border border-white/55 rounded-xl p-3 shadow-sm text-center flex flex-col items-center justify-center">
                            <Award className="w-5 h-5 text-purple-650 mb-1" />
                            <span className="text-sm font-black text-indigo-950">85%</span>
                            <span className="text-[8px] text-neutral-500 uppercase tracking-wider font-bold mt-0.5">Avg Score</span>
                          </div>
                          <div className="bg-white/45 backdrop-blur-sm border border-white/55 rounded-xl p-3 shadow-sm text-center flex flex-col items-center justify-center">
                            <Smartphone className="w-5 h-5 text-indigo-650 mb-1" />
                            <span className="text-sm font-black text-indigo-950">24</span>
                            <span className="text-[8px] text-neutral-500 uppercase tracking-wider font-bold mt-0.5">Sessions</span>
                          </div>
                        </div>

                        {/* Streak row */}
                        <div className="bg-white/45 backdrop-blur-sm rounded-xl p-3 shadow-sm border-l-4 border-l-indigo-600 border border-white/55 flex items-center justify-between">
                          <div className="flex items-center gap-2">
                            <div className="w-8 h-8 rounded-full bg-white/50 border border-white/60 flex items-center justify-center text-indigo-650">
                              <Sparkles className="w-4 h-4" />
                            </div>
                            <div className="text-left">
                              <h4 className="text-[11px] font-bold text-indigo-950">Current Streak</h4>
                              <p className="text-[9px] text-neutral-500 font-bold">Keep up the momentum!</p>
                            </div>
                          </div>
                          <span className="text-lg font-black text-indigo-700">5 <span className="text-[10px] text-neutral-500">days</span></span>
                        </div>

                        {/* Professional Bio Info */}
                        <div className="bg-white/45 backdrop-blur-sm rounded-xl p-3 border border-white/55 flex flex-col gap-2 text-left">
                          <div className="flex justify-between items-center pb-1.5 border-b border-indigo-950/5">
                            <span className="text-[9px] font-black text-indigo-950 tracking-wider">EXECUTIVE BIO & INFO</span>
                            <button type="button" onClick={handleStartEditing} className="text-indigo-600 hover:text-indigo-800 text-[10px] font-extrabold flex items-center gap-0.5 cursor-pointer">
                              <Edit2 className="w-3 h-3 animate-pulse" /> Edit Info
                            </button>
                          </div>
                          <div className="flex flex-col gap-1.5 pt-0.5">
                            <div className="flex justify-between items-center">
                              <span className="text-[9px] font-bold text-neutral-500">Phone:</span>
                              <span className="text-[10px] font-black text-indigo-950">{profilePhone}</span>
                            </div>
                            <div>
                              <span className="text-[9px] font-bold text-neutral-500 block">Personal Profile Quote:</span>
                              <p className="text-[11px] text-neutral-600 font-semibold italic mt-0.5 leading-snug">
                                "{profileBio}"
                              </p>
                            </div>
                          </div>
                        </div>

                        {/* Settings parameters */}
                        <div className="flex flex-col gap-1.5">
                          <button type="button" onClick={handleStartEditing} className="w-full bg-white/45 border border-white/55 hover:bg-white/60 rounded-lg p-2.5 flex items-center justify-between text-xs text-indigo-950 font-bold transition-all cursor-pointer">
                            <span className="flex items-center gap-2"><User className="w-4 h-4" /> Account Settings</span> <ChevronRight className="w-3.5 h-3.5" />
                          </button>
                          <button type="button" className="w-full bg-white/45 border border-white/55 hover:bg-white/60 rounded-lg p-2.5 flex items-center justify-between text-xs text-indigo-950 font-bold transition-all cursor-pointer">
                            <span className="flex items-center gap-2"><Bell className="w-4 h-4" /> Alerts Notifications</span> <ChevronRight className="w-3.5 h-3.5" />
                          </button>
                        </div>

                        <button type="button" onClick={() => setActiveScreen('login')} className="w-full bg-red-100 hover:bg-red-200 text-red-700 py-2 rounded-xl text-xs font-bold flex items-center justify-center gap-1.5 transition-colors border border-red-200 cursor-pointer">
                          <LogOut className="w-4 h-4" /> Logout
                        </button>
                      </div>
                    )}

                    {/* Bottom menu bar mockup */}
                    <div className="bg-white/40 backdrop-blur-md border-t border-white/50 px-4 py-2 flex items-center justify-between shrink-0 relative z-20">
                      <button type="button" onClick={() => { setIsEditingProfile(false); setActiveScreen('dashboard'); }} className="flex flex-col items-center justify-center text-slate-400 hover:text-indigo-900 px-3 py-1 cursor-pointer font-bold duration-100">
                        <Smartphone className="w-5 h-5" />
                        <span className="text-[8px] mt-1">Home</span>
                      </button>
                      <button type="button" onClick={() => { setIsEditingProfile(false); setActiveScreen('history'); }} className="flex flex-col items-center justify-center text-slate-400 hover:text-indigo-900 px-3 py-1 cursor-pointer font-bold duration-100">
                        <History className="w-5 h-5" />
                        <span className="text-[8px] mt-1">History</span>
                      </button>
                      <button type="button" onClick={() => { setIsEditingProfile(false); }} className={`flex flex-col items-center justify-center rounded-xl px-3 py-1 scale-95 duration-100 font-bold shadow-sm cursor-pointer ${!isEditingProfile ? 'bg-white/60 border border-white/70 text-indigo-700' : 'text-slate-400 hover:text-indigo-900'}`}>
                        <User className="w-5 h-5" />
                        <span className="text-[8px] font-bold mt-1">Profile</span>
                      </button>
                    </div>
                  </div>
                )}

              </div>
            </div>
            
            {/* Phone Home Indicator bar */}
            <div className="absolute bottom-1.5 left-1/2 -translate-x-1/2 w-32 h-1 bg-slate-700 rounded-full z-10" />
          </div>
        </div>

        {/* RIGHT COLUMN: The Interactive Code Playground, Architecture File Tree and Style Guides */}
        <div className="flex-1 bg-slate-950 flex flex-col border-t lg:border-t-0 lg:border-l border-slate-900 overflow-hidden">
          
          {/* Workspaces Tabs selector */}
          <div className="bg-slate-950 border-b border-slate-900 px-4 flex items-center gap-1 shrink-0">
            <button 
              onClick={() => setActiveTab('preview')}
              className={`px-4 py-3 text-xs font-bold transition-all border-b-2 flex items-center gap-2 ${activeTab === 'preview' ? 'text-indigo-400 border-indigo-500 bg-indigo-950/20' : 'text-slate-400 border-transparent hover:text-slate-200'}`}
            >
              <Smartphone className="w-4 h-4" /> Layout Inspector
            </button>
            <button 
              onClick={() => setActiveTab('code')}
              className={`px-4 py-3 text-xs font-bold transition-all border-b-2 flex items-center gap-2 ${activeTab === 'code' ? 'text-indigo-400 border-indigo-500 bg-indigo-950/20' : 'text-slate-400 border-transparent hover:text-slate-200'}`}
            >
              <Code className="w-4 h-4" /> Generated Flutter Modules
            </button>
            <button 
              onClick={() => setActiveTab('specs')}
              className={`px-4 py-3 text-xs font-bold transition-all border-b-2 flex items-center gap-2 ${activeTab === 'specs' ? 'text-indigo-400 border-indigo-500 bg-indigo-950/20' : 'text-slate-400 border-transparent hover:text-slate-200'}`}
            >
              <Sliders className="w-4 h-4" /> Design System Specifications
            </button>
          </div>

          {/* TAB 1: SCREEN ANALYSIS & SIMULATOR DETAILS */}
          {activeTab === 'preview' && (
            <div className="flex-1 p-6 overflow-y-auto flex flex-col gap-6">
              <div className="bg-slate-900/40 rounded-xl p-5 border border-slate-900">
                <h3 className="text-sm font-bold text-white mb-2">Analyzing Screen: {SCREENS.find(s => s.id === activeScreen)?.name}</h3>
                <p className="text-xs text-slate-400 leading-relaxed">
                  Below is the layout specification detected for state match in Flutter. By combining flexible layout builders, responsive media queries, and material 3 styling containers, we correspond precisely with the original HTML screen templates.
                </p>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="bg-slate-900/20 rounded-xl p-4 border border-slate-900">
                  <h4 className="text-xs font-bold text-indigo-400 uppercase tracking-widest mb-3 flex items-center gap-1">
                    <FolderTree className="w-4 h-4" /> Layout Constraints
                  </h4>
                  <ul className="text-xs text-slate-300 space-y-2">
                    <li className="flex items-start gap-1.5">
                      <span className="text-indigo-500 mt-1">•</span>
                      <span><strong>Max Width:</strong> Standard 600px outer box wrapping to preserve single-pane clarity on larger tablet and web layouts.</span>
                    </li>
                    <li className="flex items-start gap-1.5">
                      <span className="text-indigo-500 mt-1">•</span>
                      <span><strong>Flexible Scrolling:</strong> Custom inner ScrollViews integrated cleanly to skip pixel-overflowing during scale updates.</span>
                    </li>
                  </ul>
                </div>

                <div className="bg-slate-900/20 rounded-xl p-4 border border-slate-900">
                  <h4 className="text-xs font-bold text-purple-400 uppercase tracking-widest mb-3 flex items-center gap-1">
                    <Grid className="w-4 h-4" /> Reusable Flutter Widgets
                  </h4>
                  <ul className="text-xs text-slate-300 space-y-2">
                    <li className="flex items-start gap-1.5">
                      <span className="text-purple-500 mt-1">•</span>
                      <span><strong>CustomCard Widget:</strong> Centralizes shadow elevation values (0px Y, 15px Blur, 4% Opacity) and borders.</span>
                    </li>
                    <li className="flex items-start gap-1.5">
                      <span className="text-purple-500 mt-1">•</span>
                      <span><strong>CustomButton Widget:</strong> Handles full-width transitions and icons automatically relative to state variables.</span>
                    </li>
                  </ul>
                </div>
              </div>

              {/* Live interactive flow guidelines */}
              <div className="bg-indigo-950/20 rounded-xl p-5 border border-indigo-900/40">
                <h4 className="text-xs font-bold text-indigo-400 uppercase tracking-widest mb-2 flex items-center gap-1.5">
                  <Sparkles className="w-4 h-4 text-indigo-400 animate-spin" /> Interactive Flow Simulator
                </h4>
                <p className="text-xs text-slate-300 leading-relaxed">
                  Try clicking and navigating directly inside the phone screen mockup! Clicking the buttons or links will update the active screen state with realistic mock data transitions.
                </p>
              </div>
            </div>
          )}

          {/* TAB 2: EXPORTABLE FLUTTER & DART CODE */}
          {activeTab === 'code' && (
            <div className="flex-1 flex flex-col min-h-0 md:flex-row">
              {/* File tree sidebar */}
              <div className="w-full md:w-56 bg-slate-950 border-b md:border-b-0 md:border-r border-slate-900 p-3 flex flex-col gap-1 shrink-0 overflow-y-auto">
                <span className="text-[10px] font-bold text-slate-500 uppercase tracking-widest px-2 mb-2">Project Files</span>
                
                {FLUTTER_CODE_FILES.map(file => (
                  <button
                    key={file.path}
                    onClick={() => setSelectedFile(file)}
                    className={`w-full text-left px-3 py-2 rounded-lg text-xs font-medium flex items-center justify-between transition-colors ${selectedFile.path === file.path ? 'bg-indigo-950/40 text-indigo-400 font-bold border border-indigo-900/30' : 'text-slate-400 hover:text-slate-200'}`}
                  >
                    <span className="truncate">{file.label}</span>
                    <span className="text-[8px] opacity-60 uppercase">{file.type}</span>
                  </button>
                ))}
              </div>

              {/* Code viewer main body */}
              <div className="flex-1 flex flex-col min-h-0 bg-slate-950 p-4">
                <div className="flex items-center justify-between border-b border-slate-900 pb-3 mb-3 text-xs text-slate-400">
                  <span className="font-mono text-[11px] text-slate-300">{selectedFile.path}</span>
                  <span className="bg-slate-900 border border-slate-800 text-slate-400 font-mono text-[10px] px-2 py-0.5 rounded">Dart</span>
                </div>
                
                <div className="flex-1 overflow-y-auto border border-slate-900 rounded-xl bg-slate-950/80 p-4 font-mono text-xs text-slate-300">
                  <pre className="whitespace-pre-wrap leading-relaxed select-text">{selectedFile.code}</pre>
                </div>
              </div>
            </div>
          )}

          {/* TAB 3: COMPLETE DESIGN SYSTEM SPECIFICATION */}
          {activeTab === 'specs' && (
            <div className="flex-1 p-6 overflow-y-auto flex flex-col gap-6">
              <div className="bg-slate-900/40 border border-slate-900 rounded-xl p-5">
                <h3 className="text-sm font-bold text-white mb-2">Design System Mapping</h3>
                <p className="text-xs text-slate-400 leading-relaxed">
                  These design system definitions correspond directly with the Material 3 themes and font constants in your generated Flutter codebase.
                </p>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                {/* Spacers */}
                <div className="bg-slate-900/20 border border-slate-900 rounded-xl p-4">
                  <h4 className="text-xs font-bold text-slate-400 uppercase tracking-widest mb-3 flex items-center gap-1">
                    <Sliders className="w-4 h-4" /> Spacing Rhythm
                  </h4>
                  <ul className="text-xs space-y-2 text-slate-300">
                    <li>• margin_page: <strong>24.0 dps</strong></li>
                    <li>• stack_sm: <strong>8.0 dps</strong></li>
                    <li>• stack_md: <strong>16.0 dps</strong></li>
                    <li>• stack_lg: <strong>24.0 dps</strong></li>
                    <li>• stack_xl: <strong>40.0 dps</strong></li>
                  </ul>
                </div>

                {/* Colors */}
                <div className="bg-slate-900/20 border border-slate-900 rounded-xl p-4">
                  <h4 className="text-xs font-bold text-slate-400 uppercase tracking-widest mb-3 flex items-center gap-1">
                    <Palette className="w-4 h-4" /> Core Theme Colors
                  </h4>
                  <ul className="text-xs space-y-2 text-slate-300">
                    <li>• primary: <strong className="text-xs text-indigo-400">#3525CD</strong></li>
                    <li>• secondary: <strong className="text-xs text-purple-400">#712AE2</strong></li>
                    <li>• background: <strong>#F8F9FF</strong></li>
                    <li>• surfaceContainer: <strong>#FFFFFF</strong></li>
                  </ul>
                </div>

                {/* Radius */}
                <div className="bg-slate-900/20 border border-slate-900 rounded-xl p-4">
                  <h4 className="text-xs font-bold text-slate-400 uppercase tracking-widest mb-3 flex items-center gap-1">
                    <Fingerprint className="w-4 h-4" /> Shape Profiles
                  </h4>
                  <ul className="text-xs space-y-2 text-slate-300">
                    <li>• Input Fields: <strong>8.0 radius</strong></li>
                    <li>• Custom Cards: <strong>16.0 radius</strong></li>
                    <li>• Navigation Sheets: <strong>24.0 radius</strong></li>
                  </ul>
                </div>
              </div>
            </div>
          )}

        </div>

      </div>

    </div>
  );
}
