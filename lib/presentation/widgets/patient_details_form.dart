import 'package:flutter/material.dart';

class PatientDetailsForm extends StatelessWidget {
  final TextEditingController? nameController;
  final TextEditingController? ageController;
  final TextEditingController? phoneController;
  final TextEditingController? symptomsController;
  final TextEditingController? concernsController;
  final String? selectedGender;
  final Function(String?)? onGenderChanged;

  const PatientDetailsForm({
    super.key,
    this.nameController,
    this.ageController,
    this.phoneController,
    this.symptomsController,
    this.concernsController,
    this.selectedGender,
    this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          if (nameController != null) ...[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (ageController != null || onGenderChanged != null)
            Row(
              children: [
                if (ageController != null)
                  Expanded(
                    child: TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.cake),
                      ),
                    ),
                  ),
                if (ageController != null && onGenderChanged != null)
                  const SizedBox(width: 16),
                if (onGenderChanged != null)
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.wc),
                      ),
                      items: ['Male', 'Female', 'Other']
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                      onChanged: onGenderChanged,
                    ),
                  ),
              ],
            ),
          if (phoneController != null) ...[
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
          ],
          if (symptomsController != null) ...[
            const SizedBox(height: 16),
            TextField(
              controller: symptomsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Symptoms',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.medical_services),
                hintText: 'Describe your symptoms',
              ),
            ),
          ],
          if (concernsController != null) ...[
            const SizedBox(height: 16),
            TextField(
              controller: concernsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Concerns',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
                hintText: 'Any specific concerns?',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
