import 'package:flutter/material.dart';
import '../data/avatar_data.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  Avatar? selectedAvatar;

  void _handleLogin() {
    if (nameController.text.isNotEmpty && 
        emailController.text.isNotEmpty && 
        selectedAvatar != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userName: nameController.text.trim(),
            userEmail: emailController.text.trim(),
            userAvatar: selectedAvatar!.imageUrl,
          ),
        ),
      );
    } else {
      String message = '';
      if (nameController.text.isEmpty) message = 'Please enter your name';
      if (emailController.text.isEmpty) message = 'Please enter your email';
      if (selectedAvatar == null) message = 'Please choose an avatar';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLogo(),
                const SizedBox(height: 48),
                _buildTitle(),
                const SizedBox(height: 32),
                _buildAvatarSection(),
                const SizedBox(height: 24),
                _buildNameField(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 32),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.auto_stories, size: 40, color: Colors.white),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Digital Library',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your Online Bookstore & Library',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        const Text(
          'Create Your Account',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildAvatarSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Choose Your Avatar',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildAvatarPreview(),
          const SizedBox(height: 16),
          _buildAvatarGrid(),
        ],
      ),
    );
  }

  Widget _buildAvatarPreview() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: selectedAvatar != null
            ? Image.asset(
                selectedAvatar!.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.blue.shade200,
                    child: const Icon(Icons.person, size: 40, color: Colors.white),
                  );
                },
              )
            : Container(
                color: Colors.blue.shade200,
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
      ),
    );
  }

  Widget _buildAvatarGrid() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: avatars.length,
        itemBuilder: (context, index) {
          final avatar = avatars[index];
          final isSelected = selectedAvatar?.id == avatar.id;
          return GestureDetector(
            onTap: () => setState(() => selectedAvatar = avatar),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue.shade400 : Colors.transparent,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  avatar.imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade300,
                      child: Icon(Icons.person, color: Colors.grey.shade600),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: nameController,
      decoration: const InputDecoration(
        labelText: 'Your Name',
        prefixIcon: Icon(Icons.person_outline),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email Address',
        prefixIcon: Icon(Icons.email_outlined),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _handleLogin,
      child: const Text('Enter Library →', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}