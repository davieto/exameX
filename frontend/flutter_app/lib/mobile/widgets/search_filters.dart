import 'package:flutter/material.dart';

class SearchFilters extends StatefulWidget {
  const SearchFilters({super.key});

  @override
  State<SearchFilters> createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  String proprietario = "outros";
  String tipo = "multipla";
  bool publicas = false;
  bool privadas = false;

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF9B1C3F), Color(0xFFB23359)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _searchInput("Pesquisar Questões"),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _radioGroup("Proprietário", ["outros", "minhas"], proprietario,
                  onChanged: (val) => setState(() => proprietario = val))),
              const SizedBox(width: 20),
              Expanded(child: _radioGroup("Tipo", ["multipla", "discursiva"], tipo,
                  onChanged: (val) => setState(() => tipo = val))),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text("Questões Públicas", style: TextStyle(color: Colors.white)),
                  value: publicas,
                  onChanged: (val) => setState(() => publicas = val ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.white,
                  checkColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text("Questões Privadas", style: TextStyle(color: Colors.white)),
                  value: privadas,
                  onChanged: (val) => setState(() => privadas = val ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.white,
                  checkColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _searchInput("Pesquisar Disciplinas"),
          const SizedBox(height: 10),
          _searchInput("Pesquisar Assuntos"),
        ],
      ),
    );
  }

  Widget _searchInput(String placeholder) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.95),
        hintText: placeholder,
        prefixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _radioGroup(String title, List<String> values, String groupValue,
      {required void Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        ...values.map((v) {
          String label = v == 'outros'
              ? 'De outros usuários'
              : (v == 'minhas' ? 'Minhas questões' : v.capitalize());
          return RadioListTile<String>(
            title: Text(label, style: const TextStyle(color: Colors.white)),
            value: v,
            groupValue: groupValue,
            onChanged: (val) => onChanged(val as String),
            activeColor: Colors.white,
          );
        }).toList(),
      ],
    );
  }
}

extension StringCasing on String {
  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
}