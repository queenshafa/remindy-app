import 'package:flutter/material.dart';
import 'package:remindy_app/theme/app_theme.dart';
import 'package:remindy_app/widgets/button_banner.dart';
import 'package:remindy_app/widgets/circle_icon_button.dart';

class HomeContentHeader extends StatelessWidget {
  const HomeContentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 14, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'G\'day, User!',
                style: TextStyle(
                  fontSize: 36,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  CircleIconButton(icon: Icons.settings_outlined, onTap: () {}),
                  SizedBox(width: 10),
                  CircleIconButton(
                    icon: Icons.notifications_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
          Text(
            'Are You Taking Your Meds Regularly?',
            style: AppTheme.display(),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonBanner(
                icon: Icons.link,
                onTap: () {},
                title: 'Adherence Rate',
                description: '90% Adherence',
              ),
              SizedBox(width: 10),
              ButtonBanner(
                icon: Icons.calendar_month_outlined,
                onTap: () {},
                title: 'Day 45/180',
                description: '135 Days Left',
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Meds To Take',
            textAlign: TextAlign.start,
            style: AppTheme.display(),
          ),
        ],
      ),
    );
  }
}
