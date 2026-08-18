import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializimi i Supabase
  await Supabase.initialize(
    url: 'https://kywltgbvtlwxokunqjaw.supabase.co', // Zëvendësoje me URL-në tënde
    anonKey: 'sb_publishable_nmtrczbOxxwnvWwHP0AiOQ_kjFwup0U', // Zëvendësoje me Anon Key tënde
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChronoTaxsi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChronoTaxsi - Zgjidhni Rrugën Tuaj'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClientRegisterScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Regjistrohu si Klient'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClientSearchScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.search),
                label: const Text('Jam Klient – Kërko Mjet'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverRegisterScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.drive_eta),
                label: const Text('Regjistrohu si Shofer (Shto Mjetin)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 1. Regjistrimi i Klientit ---
class ClientRegisterScreen extends StatefulWidget {
  const ClientRegisterScreen({super.key});

  @override
  State<ClientRegisterScreen> createState() => _ClientRegisterScreenState();
}

class _ClientRegisterScreenState extends State<ClientRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  void _registerClient() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await Supabase.instance.client.from('clients').insert({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('U regjistruat me sukses si klient!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ClientSearchScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gabim: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Regjistrohu si Klient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Emri Mbiemri',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v ==ica v!.isEmpty ? 'Shkruani emrin' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Numri i Telefonit',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Shkruani numrin' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _registerClient,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    chno: const Text('Vazhdo te Kërkimi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 2. Ekrani i Kërkimit të Mjetit nga Klienti ---
class ClientSearchScreen extends StatefulWidget {
  const ClientSearchScreen({super.key});

  @override
  State<ClientSearchScreen> createState() => _ClientSearchScreenState();
}

class _ClientSearchScreenState extends State<ClientSearchScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  String _selectedCategory = 'Taksi'; // Taksë, Furgon, Kamper, Motor
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  void _searchVehicles() async {
    setState(() => _isSearching = true);
    try {
      final response = await Supabase.instance.client
          .from('drivers')
          .select()
          .eq('category', _selectedCategory);

      setState(() {
        _searchResults = response;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gabim gjatë kërkimit: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kërko Mjet / Taksi - Klient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(
                labelText: 'Nga (Vendndodhja)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.my_location),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _toController,
              decoration: const InputDecoration(
                labelText: 'Për ku (Destinacioni)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Zgjidh Llojin e Mjetit',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Taksi', child: Text('🚕 Taksë')),
                DropdownMenuItem(value: 'Furgon', child: Text('🚐 Furgon')),
                DropdownMenuItem(value: 'Kamper', child: Text('🏕️ Kamper')),
                DropdownMenuItem(value: 'Motor', child: Text('🏍️ Motor')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _isSearching ? null : _searchVehicles,
              icon: const Icon(Icons.search),
              label: _isSearching
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Kërko Mjete të Lira', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(child: Text('Nuk u gjet asnjë mjet ende. Bëni një kërkim!'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final driver = _searchResults[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.directions_car, color: Colors.blue),
                            title: Text(driver['name'] ?? 'Pa emër'),
                            subtitle: Text('Mjeti: ${driver['vehicle_type']} - Qyteti: ${driver['city']}'),
                            trailing: Text(driver['category'] ?? ''),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 3. Regjistrimi i Shoferit ---
class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});

  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedZone;
  String _selectedVehicleCategory = 'Taksi';
  bool _hasConditioner = false;
  String _paymentMethod = 'Cash';
  bool _isLoading = false;

  final List<String> _albanianCities = [
    'Tiranë', 'Durrës', 'Vlorë', 'Shkodër', 'Elbasan',
    'Fier', 'Korçë', 'Berat', 'Lushnjë', 'Kavajë', 'Sarandë'
  ];

  void _registerDriver() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await Supabase.instance.client.from('drivers').insert({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'category': _selectedVehicleCategory,
          'vehicle_type': _vehicleTypeController.text.trim(),
          'city': _selectedZone,
          'description': _descriptionController.text.trim(),
          'has_conditioner': _hasConditioner,
          'payment_method': _paymentMethod,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mjeti u regjistrua me sukses në Supabase!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gabim: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Regjistrohu si Shofer - Shto Mjetin')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Emri Mbiemri / Kompania', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Shkruani emrin' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Shkruani email-in' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedVehicleCategory,
                decoration: const InputDecoration(labelText: 'Kategoria e Mjetit', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'Taksi', child: Text('🚕 Taksë')),
                  DropdownMenuItem(value: 'Furgon', child: Text('🚐 Furgon')),
                  DropdownMenuItem(value: 'Kamper', child: Text('🏕️ Kamper')),
                  DropdownMenuItem(value: 'Motor', child: Text('🏍️ Motor')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedVehicleCategory = val);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _vehicleTypeController,
                decoration: const InputDecoration(labelText: 'Modeli (p.sh. Mercedes 8 Vendesh)', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Shkruani modelin' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedZone,
                decoration: const InputDecoration(labelText: 'Zgjidh Qytetin / Zonën', border: OutlineInputBorder()),
                items: _albanianCities.map((city) {
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList(),
                onChanged: (val) => setState(() => _selectedZone = val),
                validator: (v) => v == null ? 'Zgjidhni qytetin' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Përshkrimi / Detaje shtesë', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('A ka Kondicioner?'),
                value: _hasConditioner,
                onChanged: (val) => setState(() => _hasConditioner = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _registerDriver,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Shto Mjetin në Sistem'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
