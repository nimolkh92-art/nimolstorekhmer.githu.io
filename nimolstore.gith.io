<!DOCTYPE html>
<html lang="km">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>និមល - ហាងលក់ទំនិញអនឡាញទំនើប</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts: Kantumruy Pro & Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Kantumruy+Pro:ital,wght@0,300;0,400;0,500;0,600;0,700;1,400&display=swap" rel="stylesheet">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['"Kantumruy Pro"', 'Inter', 'sans-serif'],
                    },
                    colors: {
                        brand: {
                            primary: '#4F46E5',   // Indigo
                            secondary: '#EC4899', // Pink
                            accent: '#F59E0B',    // Amber
                            dark: '#0F172A'
                        }
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-slate-50 text-slate-800 font-sans antialiased selection:bg-indigo-500 selection:text-white">

    <!-- Toast Notification Container -->
    <div id="toastContainer" class="fixed bottom-5 right-5 z-50 flex flex-col gap-2 pointer-events-none"></div>

    <!-- Top Admin / Owner Edit Bar -->
    <div class="bg-slate-900 text-white py-2.5 px-4 sticky top-0 z-40 shadow-md border-b border-slate-800">
        <div class="max-w-7xl mx-auto flex flex-wrap items-center justify-between gap-3">
            <div class="flex items-center gap-2 text-xs sm:text-sm">
                <span class="inline-flex items-center justify-center w-6 h-6 rounded-full bg-indigo-500/20 text-indigo-400">
                    <i class="fa-solid fa-wand-magic-sparkles"></i>
                </span>
                <span class="text-slate-300">សម្រាប់ម្ចាស់ហាង៖</span>
                <span id="editModeBadge" class="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-slate-700 text-slate-300">
                    កំពុងមើលធម្មតា
                </span>
            </div>

            <div class="flex items-center gap-2 sm:gap-3">
                <!-- Add Product Button (Visible in Edit Mode) -->
                <button id="addProductBtn" onclick="openProductModal()" class="hidden items-center gap-1.5 bg-emerald-500 hover:bg-emerald-600 text-white text-xs sm:text-sm font-semibold px-3.5 py-1.5 rounded-xl transition shadow-sm cursor-pointer">
                    <i class="fa-solid fa-plus"></i>
                    <span>បន្ថែមទំនិញថ្មី</span>
                </button>

                <!-- Reset Button (Visible in Edit Mode) -->
                <button id="resetDataBtn" onclick="openConfirmResetModal()" class="hidden items-center gap-1.5 bg-rose-500/20 hover:bg-rose-500 text-rose-300 hover:text-white border border-rose-500/40 text-xs sm:text-sm font-medium px-3 py-1.5 rounded-xl transition cursor-pointer">
                    <i class="fa-solid fa-rotate-left"></i>
                    <span class="hidden sm:inline">កំណត់ឡើងវិញ</span>
                </button>

                <!-- Toggle Edit Mode Switch -->
                <button id="toggleEditBtn" onclick="toggleEditMode()" class="flex items-center gap-2 bg-gradient-to-r from-indigo-500 to-pink-500 hover:from-indigo-600 hover:to-pink-600 text-white text-xs sm:text-sm font-semibold px-4 py-1.5 rounded-xl shadow-md transition cursor-pointer">
                    <i id="toggleEditIcon" class="fa-solid fa-pen-to-square"></i>
                    <span id="toggleEditText">បើកមុខងារកែប្រែតម្លៃ</span>
                </button>
            </div>
        </div>
    </div>

    <!-- Main Navigation Header -->
    <header class="bg-white/90 backdrop-blur-md border-b border-slate-200/80 sticky top-[46px] sm:top-[48px] z-30">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-20 flex items-center justify-between gap-4">
            <!-- Brand Logo & Name -->
            <div class="flex items-center gap-3">
                <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-500 flex items-center justify-center text-white shadow-lg shadow-indigo-500/30">
                    <i class="fa-solid fa-bag-shopping text-2xl"></i>
                </div>
                <div>
                    <div class="flex items-center gap-2">
                        <h1 id="storeNameNav" class="text-2xl sm:text-3xl font-extrabold bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 bg-clip-text text-transparent tracking-tight">
                            និមល
                        </h1>
                        <button onclick="openStoreInfoModal()" class="edit-only hidden text-slate-400 hover:text-indigo-600 p-1.5 rounded-lg hover:bg-indigo-50 transition" title="កែឈ្មោះហាង">
                            <i class="fa-solid fa-pen text-xs"></i>
                        </button>
                    </div>
                    <p id="storeTaglineNav" class="text-xs text-slate-500 font-medium">Nimol Online Store</p>
                </div>
            </div>

            <!-- Search Bar (Desktop) -->
            <div class="hidden md:flex flex-1 max-w-md mx-6">
                <div class="relative w-full">
                    <input type="text" id="searchInput" oninput="filterProducts()" placeholder="ស្វែងរកឈ្មោះទំនិញ..." class="w-full pl-11 pr-4 py-2.5 bg-slate-100 border border-transparent focus:bg-white focus:border-indigo-400 rounded-2xl text-sm outline-none transition">
                    <i class="fa-solid fa-magnifying-glass absolute left-4 top-1/2 -translate-y-1/2 text-slate-400"></i>
                </div>
            </div>

            <!-- Cart & Exchange Rate Info -->
            <div class="flex items-center gap-3">
                <button onclick="openStoreInfoModal()" class="hidden sm:flex items-center gap-1.5 text-xs font-medium bg-amber-50 text-amber-700 border border-amber-200/80 px-3 py-2 rounded-xl hover:bg-amber-100 transition cursor-pointer" title="អត្រាប្តូរប្រាក់">
                    <i class="fa-solid fa-coins text-amber-500"></i>
                    <span>$1 = <span id="exchangeRateDisplay">4,100</span>៛</span>
                </button>

                <button onclick="toggleCartDrawer(true)" class="relative flex items-center gap-2.5 bg-slate-900 hover:bg-indigo-600 text-white px-4 py-2.5 rounded-2xl transition shadow-md cursor-pointer">
                    <i class="fa-solid fa-cart-shopping text-base"></i>
                    <span class="hidden sm:inline text-sm font-semibold">កន្ត្រក</span>
                    <span id="cartCountBadge" class="bg-pink-500 text-white text-xs font-bold px-2 py-0.5 rounded-full">0</span>
                </button>
            </div>
        </div>
    </header>

    <!-- Hero Banner Section -->
    <section class="relative overflow-hidden bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-500 text-white">
        <!-- Decorative Background Shapes -->
        <div class="absolute -top-24 -left-24 w-96 h-96 bg-white/10 rounded-full blur-3xl pointer-events-none"></div>
        <div class="absolute -bottom-24 -right-24 w-96 h-96 bg-amber-400/20 rounded-full blur-3xl pointer-events-none"></div>

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16 relative z-10">
            <div class="max-w-3xl">
                <div class="inline-flex items-center gap-2 bg-white/15 backdrop-blur-sm border border-white/20 px-4 py-1.5 rounded-full text-xs sm:text-sm font-medium mb-5">
                    <span class="w-2 h-2 rounded-full bg-amber-300 animate-pulse"></span>
                    <span>សូមស្វាគមន៍មកកាន់ហាងអនឡាញផ្លូវការ</span>
                </div>
                
                <div class="flex flex-wrap items-center gap-3 mb-4">
                    <h2 id="storeHeroTitle" class="text-4xl sm:text-6xl font-extrabold tracking-tight drop-shadow-sm">
                        ហាងលក់ទំនិញ និមល
                    </h2>
                    <button onclick="openStoreInfoModal()" class="edit-only hidden bg-white/20 hover:bg-white/30 text-white px-3 py-2 rounded-xl text-sm font-medium backdrop-blur-sm transition cursor-pointer">
                        <i class="fa-solid fa-pen-to-square mr-1"></i> កែព័ត៌មានហាង
                    </button>
                </div>

                <p id="storeHeroDesc" class="text-base sm:text-lg text-indigo-100 leading-relaxed mb-8 max-w-2xl">
                    មានលក់ទំនិញគ្រប់ប្រភេទ គុណភាពខ្ពស់ តម្លៃសមរម្យ និងសេវាកម្មដឹកជញ្ជូនរហ័សទាន់ចិត្តទូទាំងប្រទេស។ លោកអ្នកអាចចុចបើក "មុខងារកែប្រែតម្លៃ" ខាងលើដើម្បីកែតម្លៃ និងដាក់ទំនិញថ្មីបានភ្លាមៗ!
                </p>

                <div class="flex flex-wrap items-center gap-4">
                    <a href="#productsSection" class="bg-white text-indigo-700 hover:bg-amber-300 hover:text-slate-900 font-bold px-6 py-3.5 rounded-2xl shadow-lg transition flex items-center gap-2">
                        <span>មើលទំនិញទាំងអស់</span>
                        <i class="fa-solid fa-arrow-down"></i>
                    </a>
                    <button onclick="toggleEditMode()" class="bg-slate-900/40 hover:bg-slate-900/60 border border-white/30 text-white font-semibold px-6 py-3.5 rounded-2xl backdrop-blur-sm transition flex items-center gap-2 cursor-pointer">
                        <i class="fa-solid fa-sliders"></i>
                        <span>កែសម្រួលហាង និងតម្លៃ</span>
                    </button>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Products Showcase Section -->
    <main id="productsSection" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <!-- Mobile Search & Category Filter Bar -->
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
            <div>
                <h3 class="text-2xl sm:text-3xl font-bold text-slate-900 flex items-center gap-2.5">
                    <span class="w-2.5 h-8 rounded-full bg-gradient-to-b from-indigo-500 to-pink-500"></span>
                    <span>ទំនិញដាក់តាំងលក់</span>
                </h3>
                <p class="text-sm text-slate-500 mt-1">ជ្រើសរើសទំនិញដែលអ្នកពេញចិត្ត ឬចុចកែតម្លៃដោយផ្ទាល់</p>
            </div>

            <!-- Mobile Search -->
            <div class="md:hidden relative w-full">
                <input type="text" id="mobileSearchInput" oninput="syncSearch(this.value)" placeholder="ស្វែងរកឈ្មោះទំនិញ..." class="w-full pl-10 pr-4 py-2.5 bg-white border aborder-slate-200 rounded-2xl text-sm outline-none focus:border-indigo-500">
                <i class="fa-solid fa-magnifying-glass absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400"></i>
            </div>

            <!-- Category Pills -->
            <div id="categoryTabs" class="flex items-center gap-2 overflow-x-auto pb-2 md:pb-0 no-scrollbar">
                <!-- Categories injected by JS -->
            </div>
        </div>

        <!-- Edit Mode Helpful Instruction Banner -->
        <div id="editInstructionBanner" class="hidden mb-8 bg-gradient-to-r from-amber-50 to-orange-50 border border-amber-200 rounded-2xl p-4 sm:p-5 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 shadow-sm">
            <div class="flex items-start gap-3.5">
                <div class="w-10 h-10 rounded-xl bg-amber-500 text-white flex items-center justify-center shrink-0 mt-0.5">
                    <i class="fa-solid fa-pen-ruler text-lg"></i>
                </div>
                <div>
                    <h4 class="font-bold text-amber-900 text-base">មុខងារកែប្រែទំនិញ និងតម្លៃកំពុងដំណើរការ!</h4>
                    <p class="text-xs sm:text-sm text-amber-800 mt-0.5">
                        អ្នកអាចចុចលើប៊ូតុង <strong class="underline">"កែតម្លៃ / កែព័ត៌មាន"</strong> នៅលើកាតទំនិញនីមួយៗ ដើម្បីប្តូរឈ្មោះ តម្លៃ រូបភាព ឬចុច "+ បន្ថែមទំនិញថ្មី"។ រាល់ការកែប្រែត្រូវបានរក្សាទុកដោយស្វ័យប្រវត្តិ។
                    </p>
                </div>
            </div>
            <button onclick="openProductModal()" class="shrink-0 bg-amber-500 hover:bg-amber-600 text-white font-bold text-sm px-4 py-2.5 rounded-xl shadow transition cursor-pointer">
                <i class="fa-solid fa-plus mr-1"></i> បន្ថែមទំនិញថ្មី
            </button>
        </div>

        <!-- Product Grid -->
        <div id="productGrid" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <!-- Product Cards rendered via JavaScript -->
        </div>

        <!-- Empty Search State -->
        <div id="emptyState" class="hidden text-center py-16 bg-white rounded-3xl border border-slate-200/80 shadow-sm">
            <div class="w-16 h-16 bg-slate-100 text-slate-400 rounded-full flex items-center justify-center mx-auto mb-4 text-2xl">
                <i class="fa-solid fa-box-open"></i>
            </div>
            <h4 class="text-lg font-bold text-slate-800">មិនមានទំនិញដែលអ្នកស្វែងរកទេ</h4>
            <p class="text-sm text-slate-500 mt-1 mb-5">សូមសាកល្បងស្វែងរកពាក្យផ្សេង ឬបន្ថែមទំនិញថ្មី</p>
            <button onclick="resetFilters()" class="bg-indigo-600 text-white text-sm font-semibold px-5 py-2.5 rounded-xl hover:bg-indigo-700 transition cursor-pointer">
                បង្ហាញទំនិញទាំងអស់វិញ
            </button>
        </div>
    </main>

    <!-- Footer Section -->
    <footer class="bg-slate-900 text-slate-300 border-t border-slate-800 mt-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <!-- Brand Info -->
                <div>
                    <div class="flex items-center gap-3 mb-4">
                        <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 to-pink-500 flex items-center justify-center text-white">
                            <i class="fa-solid fa-bag-shopping text-lg"></i>
                        </div>
                        <span id="storeNameFooter" class="text-2xl font-extrabold text-white">និមល</span>
                    </div>
                    <p id="footerAboutText" class="text-sm text-slate-400 leading-relaxed mb-4">
                        ហាងលក់ទំនិញអនឡាញ និមល ផ្តល់ជូននូវផលិតផលមានគុណភាព តម្លៃសមរម្យ និងទំនុកចិត្តខ្ពស់ជូនដល់អតិថិជនគ្រប់រូប។
                    </p>
                    <button onclick="openStoreInfoModal()" class="edit-only hidden text-xs bg-indigo-500/20 text-indigo-300 border border-indigo-500/40 px-3 py-1.5 rounded-lg hover:bg-indigo-500 hover:text-white transition cursor-pointer">
                        <i class="fa-solid fa-pen mr-1"></i> កែព័ត៌មានទំនាក់ទំនងហាង
                    </button>
                </div>

                <!-- Contact Info -->
                <div>
                    <h4 class="text-white font-bold text-base mb-4">ទំនាក់ទំនងមកកាន់យើង</h4>
                    <ul class="space-y-3 text-sm">
                        <li class="flex items-center gap-3">
                            <span class="w-8 h-8 rounded-lg bg-slate-800 flex items-center justify-center text-pink-400">
                                <i class="fa-solid fa-phone"></i>
                            </span>
                            <span id="storePhoneFooter">012 345 678 / 098 765 432</span>
                        </li>
                        <li class="flex items-center gap-3">
                            <span class="w-8 h-8 rounded-lg bg-slate-800 flex items-center justify-center text-indigo-400">
                                <i class="fa-brands fa-telegram"></i>
                            </span>
                            <span id="storeTelegramFooter">@NimolStoreKH</span>
                        </li>
                        <li class="flex items-start gap-3">
                            <span class="w-8 h-8 rounded-lg bg-slate-800 flex items-center justify-center text-amber-400 shrink-0">
                                <i class="fa-solid fa-location-dot"></i>
                            </span>
                            <span id="storeAddressFooter">រាជធានីភ្នំពេញ, ព្រះរាជាណាចក្រកម្ពុជា</span>
                        </li>
                    </ul>
                </div>

                <!-- Quick Actions -->
                <div>
                    <h4 class="text-white font-bold text-base mb-4">សេវាកម្មអតិថិជន</h4>
                    <ul class="space-y-2.5 text-sm text-slate-400">
                        <li><i class="fa-solid fa-check text-emerald-400 mr-2"></i> ធានាគុណភាពទំនិញសុទ្ធ ១០០%</li>
                        <li><i class="fa-solid fa-check text-emerald-400 mr-2"></i> ដឹកជញ្ជូនរហ័ស ២៥ ខេត្ត/ក្រុង</li>
                        <li><i class="fa-solid fa-check text-emerald-400 mr-2"></i> អាចបង់ប្រាក់ពេលទទួលបានទំនិញ</li>
                    </ul>
                </div>
            </div>

            <div class="border-t border-slate-800 mt-10 pt-6 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-slate-500">
                <p>© 2026 <span id="storeCopyrightName">និមល (Nimol Store)</span>. រក្សាសិទ្ធិគ្រប់យ៉ាង។</p>
                <p>រចនាឡើងសម្រាប់ការលក់ទំនិញអនឡាញងាយស្រួលកែតម្លៃ</p>
            </div>
        </div>
    </footer>

    <!-- ========================================== -->
    <!-- MODAL 1: ADD / EDIT PRODUCT MODAL          -->
    <!-- ========================================== -->
    <div id="productModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4 overflow-y-auto">
        <div class="bg-white rounded-3xl max-w-lg w-full shadow-2xl border border-slate-100 overflow-hidden my-auto">
            <div class="bg-gradient-to-r from-indigo-600 to-pink-500 px-6 py-4 flex items-center justify-between text-white">
                <h3 id="productModalTitle" class="text-lg font-bold flex items-center gap-2">
                    <i class="fa-solid fa-tag"></i>
                    <span>កែប្រែព័ត៌មានទំនិញ និងតម្លៃ</span>
                </h3>
                <button onclick="closeProductModal()" class="w-8 h-8 rounded-full bg-white/20 hover:bg-white/30 flex items-center justify-center transition cursor-pointer">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>

            <form id="productForm" onsubmit="saveProduct(event)" class="p-6 space-y-4">
                <input type="hidden" id="prodId">

                <!-- Product Name -->
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-1">ឈ្មោះទំនិញ *</label>
                    <input type="text" id="prodName" required placeholder="ឧទាហរណ៍៖ កាបូបស្ពាយនារីម៉ូតថ្មី" class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:bg-white focus:border-indigo-500 outline-none transition">
                </div>

                <!-- Price & Original Price (for discount display) -->
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-1">តម្លៃលក់ ($) *</label>
                        <div class="relative">
                            <span class="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 font-bold">$</span>
                            <input type="number" id="prodPrice" step="0.01" min="0" required placeholder="15.00" oninput="updateLiveKhrPreview()" class="w-full pl-8 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm font-bold text-indigo-600 focus:bg-white focus:border-indigo-500 outline-none transition">
                        </div>
                        <p class="text-xs text-slate-500 mt-1">ស្មើនឹង៖ <span id="liveKhrPreview" class="font-semibold text-slate-700">0 ៛</span></p>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-1">តម្លៃដើម (បើមានបញ្ចុះតម្លៃ)</label>
                        <div class="relative">
                            <span class="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 font-bold">$</span>
                            <input type="number" id="prodOldPrice" step="0.01" min="0" placeholder="20.00" class="w-full pl-8 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm text-slate-600 focus:bg-white focus:border-indigo-500 outline-none transition">
                        </div>
                        <p class="text-xs text-slate-400 mt-1">ទុកទំនេរបើមិនបញ្ចុះតម្លៃ</p>
                    </div>
                </div>

                <!-- Category & Badge -->
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-1">ប្រភេទទំនិញ</label>
                        <input type="text" id="prodCategory" list="categorySuggestions" placeholder="ឧ. សម្លៀកបំពាក់" class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:bg-white focus:border-indigo-500 outline-none transition">
                        <datalist id="categorySuggestions">
                            <option value="សម្លៀកបំពាក់">
                            <option value="គ្រឿងសម្អាង">
                            <option value="កាបូប និងស្បែកជើង">
                            <option value="គ្រឿងអេឡិចត្រូនិច">
                            <option value="សម្ភារៈប្រើប្រាស់">
                        </datalist>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-1">ស្លាកពិសេស (Badge)</label>
                        <input type="text" id="prodBadge" placeholder="ឧ. លក់ដាច់ខ្លាំង / ថ្មី" class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:bg-white focus:border-indigo-500 outline-none transition">
                    </div>
                </div>

                <!-- Image Selection (Upload or URL or Emoji Icon) -->
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-1">រូបភាពទំនិញ (ដាក់ Link ឬ ជ្រើសរើសពីម៉ាស៊ីន)</label>
                    <div class="flex items-center gap-3">
                        <img id="prodImgPreview" src="https://placehold.co/200x200/e0e7ff/4f46e5?text=Nimol" alt="Preview" class="w-16 h-16 rounded-2xl object-cover border border-slate-200 shrink-0 bg-slate-100">
                        <div class="flex-1 space-y-2">
                            <input type="text" id="prodImageUrl" oninput="previewImageUrl(this.value)" placeholder="បិទភ្ជាប់ Link រូបភាព (https://...)" class="w-full px-3.5 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:bg-white focus:border-indigo-500 outline-none">
                            <label class="inline-flex items-center gap-2 text-xs font-semibold text-indigo-600 hover:text-indigo-700 bg-indigo-50 hover:bg-indigo-100 px-3 py-1.5 rounded-lg cursor-pointer transition">
                                <i class="fa-solid fa-upload"></i>
                                <span>ជ្រើសរើសរូបភាពពីទូរស័ព្ទ/កុំព្យូទ័រ</span>
                                <input type="file" accept="image/*" onchange="handleImageUpload(event)" class="hidden">
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Description -->
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-1">ការពិពណ៌នាខ្លីៗ</label>
                    <textarea id="prodDesc" rows="2" placeholder="បញ្ជាក់ពីគុណភាព ទំហំ ឬពណ៌របស់ទំនិញ..." class="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:bg-white focus:border-indigo-500 outline-none transition"></textarea>
                </div>

                <!-- Action Buttons -->
                <div class="flex items-center justify-end gap-3 pt-3 border-t border-slate-100">
                    <button type="button" onclick="closeProductModal()" class="px-5 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-slate-100 transition cursor-pointer">
                        បោះបង់
                    </button>
                    <button type="submit" class="px-6 py-2.5 rounded-xl text-sm font-bold text-white bg-gradient-to-r from-indigo-600 to-pink-500 hover:from-indigo-700 hover:to-pink-600 shadow-md transition cursor-pointer">
                        <i class="fa-solid fa-check mr-1"></i> រក្សាទុកទំនិញ
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ========================================== -->
    <!-- MODAL 2: STORE SETTINGS / INFO MODAL       -->
    <!-- ========================================== -->
    <div id="storeInfoModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4 overflow-y-auto">
        <div class="bg-white rounded-3xl max-w-lg w-full shadow-2xl border border-slate-100 overflow-hidden my-auto">
            <div class="bg-slate-900 px-6 py-4 flex items-center justify-between text-white">
                <h3 class="text-lg font-bold flex items-center gap-2">
                    <i class="fa-solid fa-store text-pink-400"></i>
                    <span>កែប្រែព័ត៌មានហាង និងអត្រាប្តូរប្រាក់</span>
                </h3>
                <button onclick="closeStoreInfoModal()" class="w-8 h-8 rounded-full bg-white/10 hover:bg-white/20 flex items-center justify-center transition cursor-pointer">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>

            <form onsubmit="saveStoreInfo(event)" class="p-6 space-y-4">
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-1">ឈ្មោះហាង</label>
                        <input type="text" id="inputStoreName" required class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm font-bold focus:bg-white focus:border-indigo-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-1">អត្រាប្តូរប្រាក់ ($1 = ? ៛)</label>
                        <input type="number" id="inputExchangeRate" required min="1000" step="50" class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm font-bold text-amber-600 focus:bg-white focus:border-indigo-500 outline-none">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-1">ពាក្យស្វាគមន៍លើផ្ទាំងធំ (Hero Description)</label>
                    <textarea id="inputStoreDesc" rows="2" class="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:bg-white focus:border-indigo-500 outline-none"></textarea>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-1">លេខទូរស័ព្ទទំនាក់ទំនង</label>
                        <input type="text" id="inputStorePhone" class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:bg-white focus:border-indigo-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-1">Telegram / Facebook</label>
                        <input type="text" id="inputStoreTelegram" class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:bg-white focus:border-indigo-500 outline-none">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-1">អាសយដ្ឋានហាង</label>
                    <input type="text" id="inputStoreAddress" class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:bg-white focus:border-indigo-500 outline-none">
                </div>

                <div class="flex items-center justify-end gap-3 pt-3 border-t border-slate-100">
                    <button type="button" onclick="closeStoreInfoModal()" class="px-5 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-slate-100 transition cursor-pointer">
                        បោះបង់
                    </button>
                    <button type="submit" class="px-6 py-2.5 rounded-xl text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 shadow-md transition cursor-pointer">
                        រក្សាទុកការផ្លាស់ប្តូរ
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ========================================== -->
    <!-- MODAL 3: CONFIRMATION MODAL (Delete/Reset) -->
    <!-- ========================================== -->
    <div id="confirmModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4">
        <div class="bg-white rounded-3xl max-w-sm w-full p-6 shadow-2xl text-center">
            <div class="w-14 h-14 rounded-full bg-rose-100 text-rose-600 flex items-center justify-center mx-auto mb-4 text-2xl">
                <i class="fa-solid fa-triangle-exclamation"></i>
            </div>
            <h4 id="confirmTitle" class="text-lg font-bold text-slate-900 mb-2">បញ្ជាក់ការលុប</h4>
            <p id="confirmMessage" class="text-sm text-slate-500 mb-6">តើអ្នកពិតជាចង់ធ្វើសកម្មភាពនេះមែនទេ?</p>
            <div class="flex items-center justify-center gap-3">
                <button onclick="closeConfirmModal()" class="flex-1 py-2.5 rounded-xl text-sm font-semibold text-slate-600 bg-slate-100 hover:bg-slate-200 transition cursor-pointer">
                    ទេ, រក្សាទុក
                </button>
                <button id="confirmActionBtn" class="flex-1 py-2.5 rounded-xl text-sm font-bold text-white bg-rose-600 hover:bg-rose-700 transition cursor-pointer">
                    បាទ/ចាស, យល់ព្រម
                </button>
            </div>
        </div>
    </div>

    <!-- ========================================== -->
    <!-- DRAWER 4: SHOPPING CART DRAWER             -->
    <!-- ========================================== -->
    <div id="cartDrawer" class="fixed inset-0 z-50 hidden">
        <!-- Backdrop -->
        <div onclick="toggleCartDrawer(false)" class="absolute inset-0 bg-slate-900/50 backdrop-blur-xs transition-opacity"></div>
        
        <!-- Drawer Panel -->
        <div class="absolute right-0 top-0 bottom-0 w-full max-w-md bg-white shadow-2xl flex flex-col">
            <div class="px-6 py-5 bg-slate-900 text-white flex items-center justify-between">
                <div class="flex items-center gap-2.5">
                    <i class="fa-solid fa-cart-shopping text-pink-400 text-lg"></i>
                    <h3 class="text-lg font-bold">កន្ត្រកទំនិញរបស់អ្នក</h3>
                </div>
                <button onclick="toggleCartDrawer(false)" class="w-8 h-8 rounded-full bg-white/10 hover:bg-white/20 flex items-center justify-center transition cursor-pointer">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>

            <!-- Cart Items List -->
            <div id="cartItemsContainer" class="flex-1 overflow-y-auto p-6 space-y-4">
                <!-- Cart items injected via JS -->
            </div>

            <!-- Cart Summary & Checkout -->
            <div id="cartFooter" class="p-6 bg-slate-50 border-t border-slate-200 space-y-4">
                <div class="space-y-1.5">
                    <div class="flex items-center justify-between text-sm text-slate-600">
                        <span>ចំនួនទំនិញសរុប៖</span>
                        <span id="cartTotalItems" class="font-bold text-slate-900">0 មុខ</span>
                    </div>
                    <div class="flex items-center justify-between text-lg font-extrabold text-slate-900">
                        <span>ទឹកប្រាក់សរុប ($)៖</span>
                        <span id="cartTotalUsd" class="text-indigo-600">$0.00</span>
                    </div>
                    <div class="flex items-center justify-between text-sm font-bold text-pink-600">
                        <span>គិតជាប្រាក់រៀល (៛)៖</span>
                        <span id="cartTotalKhr">0 ៛</span>
                    </div>
                </div>

                <button onclick="checkoutOrder()" class="w-full py-3.5 rounded-2xl bg-gradient-to-r from-indigo-600 to-pink-500 hover:from-indigo-700 hover:to-pink-600 text-white font-bold text-base shadow-lg transition flex items-center justify-center gap-2 cursor-pointer">
                    <i class="fa-solid fa-bag-shopping"></i>
                    <span>បញ្ជាទិញឥឡូវនេះ</span>
                </button>
            </div>
        </div>
    </div>

    <!-- JavaScript Application Logic -->
    <script>
        // --- 1. DEFAULT DATA (គំរូទំនិញ និងព័ត៌មានហាងដើម) ---
        const DEFAULT_STORE_INFO = {
            name: "និមល",
            tagline: "Nimol Online Store",
            heroTitle: "ហាងលក់ទំនិញ និមល",
            heroDesc: "មានលក់ទំនិញគ្រប់ប្រភេទ គុណភាពខ្ពស់ តម្លៃសមរម្យ និងសេវាកម្មដឹកជញ្ជូនរហ័សទាន់ចិត្តទូទាំងប្រទេស។ លោកអ្នកអាចចុចបើក \"មុខងារកែប្រែតម្លៃ\" ខាងលើដើម្បីកែតម្លៃ និងដាក់ទំនិញថ្មីបានភ្លាមៗ!",
            phone: "012 345 678 / 098 765 432",
            telegram: "@NimolStoreKH",
            address: "រាជធានីភ្នំពេញ, ព្រះរាជាណាចក្រកម្ពុជា",
            exchangeRate: 4100
        };

        const DEFAULT_PRODUCTS = [
            {
                id: "p1",
                name: "កាបូបស្ពាយនារីម៉ូតទាន់សម័យ",
                category: "កាបូប និងស្បែកជើង",
                price: 18.50,
                oldPrice: 25.00,
                badge: "លក់ដាច់ខ្លាំង",
                image: "https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=600&q=80",
                desc: "ស្បែកទន់ស្អាត ធន់នឹងការប្រើប្រាស់ មានច្រើនពណ៌សម្រាប់ជ្រើសរើស។"
            },
            {
                id: "p2",
                name: "ឈុតគ្រឿងសម្អាងថែរក្សាស្បែកមុខ",
                category: "គ្រឿងសម្អាង",
                price: 24.00,
                oldPrice: 30.00,
                badge: "ផលិតផលថ្មី",
                image: "https://images.unsplash.com/photo-1596462502278-27bfdc403348?auto=format&fit=crop&w=600&q=80",
                desc: "ជួយផ្តល់សំណើម ធ្វើឱ្យស្បែកមុខភ្លឺថ្លា ម៉ដ្ឋរលោងបែបធម្មជាតិ។"
            },
            {
                id: "p3",
                name: "នាឡិកាដៃឆ្លាតវៃ Smart Watch Pro",
                category: "គ្រឿងអេឡិចត្រូនិច",
                price: 35.00,
                oldPrice: 45.00,
                badge: "បញ្ចុះតម្លៃ",
                image: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80",
                desc: "អាចភ្ជាប់ជាមួយទូរស័ព្ទ iOS និង Android វាស់ចង្វាក់បេះដូង និងការពារជម្រាបទឹក។"
            },
            {
                id: "p4",
                name: "អាវយឺតកប្បាសសុទ្ធប្រណិត",
                category: "សម្លៀកបំពាក់",
                price: 12.00,
                oldPrice: null,
                badge: "ពេញនិយម",
                image: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=600&q=80",
                desc: "សាច់ក្រណាត់ទន់ត្រជាក់ ងាយស្រួលពាក់ មិនយារ មិនហើរពណ៌។"
            },
            {
                id: "p5",
                name: "ស្បែកជើងប៉ាត់តាកីឡាស្រាល",
                category: "កាបូប និងស្បែកជើង",
                price: 28.00,
                oldPrice: 35.00,
                badge: "",
                image: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=600&q=80",
                desc: "បាតទន់ស្រាល ពាក់ដើរឬហាត់ប្រាណមិនឈឺជើង មានគ្រប់លេខ។"
            },
            {
                id: "p6",
                name: "កាសប្លូធូសឥតខ្សែ សំឡេងពិរោះ",
                category: "គ្រឿងអេឡិចត្រូនិច",
                price: 19.50,
                oldPrice: null,
                badge: "ថ្មី",
                image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=600&q=80",
                desc: "កាត់បន្ថយសំឡេងរំខាន កាន់ថ្មបានយូររហូតដល់ ២៤ ម៉ោង។"
            },
            {
                id: "p7",
                name: "ទឹកអប់ក្លិនផ្កាក្រអូបជាប់បានយូរ",
                category: "គ្រឿងសម្អាង",
                price: 22.00,
                oldPrice: 28.00,
                badge: "ណែនាំ",
                image: "https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=600&q=80",
                desc: "ក្លិនក្រអូបស្រស់ស្រាយ ទាក់ទាញ ជាប់ក្លិនបានពេញមួយថ្ងៃ។"
            },
            {
                id: "p8",
                name: "ដបទឹករក្សាកម្តៅអ៊ីណុក 500ml",
                category: "សម្ភារៈប្រើប្រាស់",
                price: 8.50,
                oldPrice: 12.00,
                badge: "តម្លៃពិសេស",
                image: "https://images.unsplash.com/photo-1602143407151-7111542de6e8?auto=format&fit=crop&w=600&q=80",
                desc: "រក្សាទឹកក្តៅ ឬទឹកត្រជាក់បានរហូតដល់ ១២ ម៉ោង ងាយស្រួលយកតាមខ្លួន។"
            }
        ];

        // --- 2. APPLICATION STATE ---
        let storeInfo = JSON.parse(localStorage.getItem('nimol_store_info')) || { ...DEFAULT_STORE_INFO };
        let products = JSON.parse(localStorage.getItem('nimol_store_products')) || [...DEFAULT_PRODUCTS];
        let cart = JSON.parse(localStorage.getItem('nimol_store_cart')) || [];
        let isEditMode = false;
        let selectedCategory = 'ទាំងអស់';
        let searchQuery = '';

        // --- 3. INITIALIZATION ---
        document.addEventListener('DOMContentLoaded', () => {
            renderStoreInfo();
            renderCategories();
            renderProducts();
            renderCart();
        });

        // --- 4. FORMATTING HELPERS ---
        function formatUsd(amount) {
            return '$' + Number(amount || 0).toFixed(2);
        }

        function formatKhr(usdAmount) {
            const khr = Math.round((Number(usdAmount) || 0) * storeInfo.exchangeRate);
            return khr.toLocaleString('en-US') + ' ៛';
        }

        function showToast(message, type = 'success') {
            const container = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            const bgColor = type === 'success' ? 'bg-slate-900 border-emerald-500' : 'bg-rose-600 border-rose-400';
            const icon = type === 'success' ? 'fa-circle-check text-emerald-400' : 'fa-circle-exclamation text-white';

            toast.className = `${bgColor} border-l-4 text-white px-4 py-3 rounded-xl shadow-xl flex items-center gap-3 text-sm font-medium transform transition-all duration-300 translate-y-2 opacity-0 pointer-events-auto`;
            toast.innerHTML = `<i class="fa-solid ${icon} text-base"></i><span>${message}</span>`;
            
            container.appendChild(toast);
            requestAnimationFrame(() => {
                toast.classList.remove('translate-y-2', 'opacity-0');
            });

            setTimeout(() => {
                toast.classList.add('opacity-0', 'translate-y-2');
                setTimeout(() => toast.remove(), 300);
            }, 2800);
        }

        // --- 5. STORE INFO RENDER & EDIT ---
        function renderStoreInfo() {
            document.title = `${storeInfo.name} - ហាងលក់ទំនិញអនឡាញ`;
            document.getElementById('storeNameNav').textContent = storeInfo.name;
            document.getElementById('storeTaglineNav').textContent = storeInfo.tagline;
            document.getElementById('storeHeroTitle').textContent = storeInfo.heroTitle;
            document.getElementById('storeHeroDesc').textContent = storeInfo.heroDesc;
            document.getElementById('exchangeRateDisplay').textContent = storeInfo.exchangeRate.toLocaleString('en-US');
            
            document.getElementById('storeNameFooter').textContent = storeInfo.name;
            document.getElementById('storePhoneFooter').textContent = storeInfo.phone;
            document.getElementById('storeTelegramFooter').textContent = storeInfo.telegram;
            document.getElementById('storeAddressFooter').textContent = storeInfo.address;
            document.getElementById('storeCopyrightName').textContent = `${storeInfo.name} (${storeInfo.tagline})`;
        }

        function openStoreInfoModal() {
            document.getElementById('inputStoreName').value = storeInfo.name;
            document.getElementById('inputExchangeRate').value = storeInfo.exchangeRate;
            document.getElementById('inputStoreDesc').value = storeInfo.heroDesc;
            document.getElementById('inputStorePhone').value = storeInfo.phone;
            document.getElementById('inputStoreTelegram').value = storeInfo.telegram;
            document.getElementById('inputStoreAddress').value = storeInfo.address;

            const modal = document.getElementById('storeInfoModal');
            modal.classList.remove('hidden');
            modal.classList.add('flex');
        }

        function closeStoreInfoModal() {
            const modal = document.getElementById('storeInfoModal');
            modal.classList.add('hidden');
            modal.classList.remove('flex');
        }

        function saveStoreInfo(e) {
            e.preventDefault();
            const newName = document.getElementById('inputStoreName').value.trim() || "និមល";
            storeInfo.name = newName;
            storeInfo.heroTitle = `ហាងលក់ទំនិញ ${newName}`;
            storeInfo.exchangeRate = Number(document.getElementById('inputExchangeRate').value) || 4100;
            storeInfo.heroDesc = document.getElementById('inputStoreDesc').value.trim();
            storeInfo.phone = document.getElementById('inputStorePhone').value.trim();
            storeInfo.telegram = document.getElementById('inputStoreTelegram').value.trim();
            storeInfo.address = document.getElementById('inputStoreAddress').value.trim();

            localStorage.setItem('nimol_store_info', JSON.stringify(storeInfo));
            renderStoreInfo();
            renderProducts();
            renderCart();
            closeStoreInfoModal();
            showToast('បានរក្សាទុកព័ត៌មានហាងដោយជោគជ័យ!');
        }

        // --- 6. EDIT MODE TOGGLE ---
        function toggleEditMode() {
            isEditMode = !isEditMode;
            const badge = document.getElementById('editModeBadge');
            const toggleBtn = document.getElementById('toggleEditBtn');
            const toggleText = document.getElementById('toggleEditText');
            const toggleIcon = document.getElementById('toggleEditIcon');
            const addBtn = document.getElementById('addProductBtn');
            const resetBtn = document.getElementById('resetDataBtn');
            const instructionBanner = document.getElementById('editInstructionBanner');
            const editOnlyEls = document.querySelectorAll('.edit-only');

            if (isEditMode) {
                badge.textContent = 'កំពុងបើកមុខងារកែប្រែ';
                badge.className = 'px-2.5 py-0.5 rounded-full text-xs font-bold bg-amber-500 text-slate-900';
                toggleText.textContent = 'រួចរាល់ (បិទការកែប្រែ)';
                toggleIcon.className = 'fa-solid fa-check';
                toggleBtn.className = 'flex items-center gap-2 bg-emerald-500 hover:bg-emerald-600 text-white text-xs sm:text-sm font-bold px-4 py-1.5 rounded-xl shadow-md transition cursor-pointer';
                
                addBtn.classList.remove('hidden');
                addBtn.classList.add('flex');
                resetBtn.classList.remove('hidden');
                resetBtn.classList.add('flex');
                instructionBanner.classList.remove('hidden');
                editOnlyEls.forEach(el => el.classList.remove('hidden'));
                showToast('បានបើកមុខងារកែប្រែ! អ្នកអាចចុចកែតម្លៃ និងទំនិញបានហើយ');
            } else {
                badge.textContent = 'កំពុងមើលធម្មតា';
                badge.className = 'px-2.5 py-0.5 rounded-full text-xs font-semibold bg-slate-700 text-slate-300';
                toggleText.textContent = 'បើកមុខងារកែប្រែតម្លៃ';
                toggleIcon.className = 'fa-solid fa-pen-to-square';
                toggleBtn.className = 'flex items-center gap-2 bg-gradient-to-r from-indigo-500 to-pink-500 hover:from-indigo-600 hover:to-pink-600 text-white text-xs sm:text-sm font-semibold px-4 py-1.5 rounded-xl shadow-md transition cursor-pointer';
                
                addBtn.classList.add('hidden');
                addBtn.classList.remove('flex');
                resetBtn.classList.add('hidden');
                resetBtn.classList.remove('flex');
                instructionBanner.classList.add('hidden');
                editOnlyEls.forEach(el => el.classList.add('hidden'));
                showToast('បានបិទមុខងារកែប្រែ និងរក្សាទុករួចរាល់');
            }
            renderProducts();
        }

        // --- 7. CATEGORIES & SEARCH FILTER ---
        function renderCategories() {
            const container = document.getElementById('categoryTabs');
            const categories = ['ទាំងអស់', ...new Set(products.map(p => p.category).filter(Boolean))];
            
            if (!categories.includes(selectedCategory)) {
                selectedCategory = 'ទាំងអស់';
            }

            container.innerHTML = categories.map(cat => {
                const active = cat === selectedCategory;
                const classes = active 
                    ? 'bg-indigo-600 text-white shadow-md shadow-indigo-500/25' 
                    : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200';
                return `
                    <button onclick="selectCategory('${cat}')" class="px-4 py-2 rounded-xl text-xs sm:text-sm font-semibold whitespace-nowrap transition cursor-pointer ${classes}">
                        ${cat}
                    </button>
                `;
            }).join('');
        }

        function selectCategory(cat) {
            selectedCategory = cat;
            renderCategories();
            renderProducts();
        }

        function syncSearch(val) {
            document.getElementById('searchInput').value = val;
            document.getElementById('mobileSearchInput').value = val;
            searchQuery = val.toLowerCase().trim();
            renderProducts();
        }

        function filterProducts() {
            const val = document.getElementById('searchInput').value;
            document.getElementById('mobileSearchInput').value = val;
            searchQuery = val.toLowerCase().trim();
            renderProducts();
        }

        function resetFilters() {
            selectedCategory = 'ទាំងអស់';
            syncSearch('');
            renderCategories();
            renderProducts();
        }

        // --- 8. RENDER PRODUCT CARDS ---
        function renderProducts() {
            const grid = document.getElementById('productGrid');
            const emptyState = document.getElementById('emptyState');

            const filtered = products.filter(p => {
                const matchCat = selectedCategory === 'ទាំងអស់' || p.category === selectedCategory;
                const matchQuery = !searchQuery || 
                    p.name.toLowerCase().includes(searchQuery) || 
                    (p.desc && p.desc.toLowerCase().includes(searchQuery)) ||
                    (p.category && p.category.toLowerCase().includes(searchQuery));
                return matchCat && matchQuery;
            });

            if (filtered.length === 0) {
                grid.innerHTML = '';
                emptyState.classList.remove('hidden');
                return;
            }

            emptyState.classList.add('hidden');
            grid.innerHTML = filtered.map(product => {
                const fallbackImg = `https://placehold.co/600x600/e0e7ff/4f46e5?text=${encodeURIComponent(product.name)}`;
                const hasDiscount = product.oldPrice && Number(product.oldPrice) > Number(product.price);

                return `
                <div class="group bg-white rounded-3xl border ${isEditMode ? 'border-amber-400 ring-2 ring-amber-400/20' : 'border-slate-200/80 hover:border-indigo-300'} overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between relative">
                    
                    <!-- Top Image Area -->
                    <div class="relative aspect-square overflow-hidden bg-slate-100">
                        <img src="${product.image || fallbackImg}" 
                             onerror="this.onerror=null; this.src='${fallbackImg}';" 
                             alt="${product.name}" 
                             class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        
                        <!-- Badge -->
                        ${product.badge ? `
                            <span class="absolute top-3 left-3 bg-gradient-to-r from-pink-500 to-rose-500 text-white text-xs font-bold px-3 py-1 rounded-full shadow-md">
                                ${product.badge}
                            </span>
                        ` : ''}

                        <!-- Category Tag -->
                        ${product.category ? `
                            <span class="absolute bottom-3 left-3 bg-slate-900/75 backdrop-blur-xs text-white text-[11px] font-medium px-2.5 py-1 rounded-lg">
                                ${product.category}
                            </span>
                        ` : ''}

                        <!-- Quick Delete Button in Edit Mode -->
                        ${isEditMode ? `
                            <button onclick="confirmDeleteProduct('${product.id}')" class="absolute top-3 right-3 w-9 h-9 rounded-xl bg-rose-500 hover:bg-rose-600 text-white shadow-lg flex items-center justify-center transition cursor-pointer" title="លុបទំនិញនេះ">
                                <i class="fa-solid fa-trash-can text-sm"></i>
                            </button>
                        ` : ''}
                    </div>

                    <!-- Card Content -->
                    <div class="p-5 flex-1 flex flex-col justify-between">
                        <div>
                            <h4 class="text-base sm:text-lg font-bold text-slate-900 line-clamp-1 group-hover:text-indigo-600 transition">
                                ${product.name}
                            </h4>
                            <p class="text-xs sm:text-sm text-slate-500 mt-1 line-clamp-2 leading-relaxed">
                                ${product.desc || 'ទំនិញមានគុណភាពល្អ តម្លៃសមរម្យ'}
                            </p>
                        </div>

                        <!-- Price Box -->
                        <div class="mt-4 pt-3 border-t border-slate-100">
                            <div class="flex items-baseline justify-between gap-2">
                                <div>
                                    <div class="flex items-baseline gap-2">
                                        <span class="text-2xl font-extrabold text-indigo-600">
                                            ${formatUsd(product.price)}
                                        </span>
                                        ${hasDiscount ? `
                                            <span class="text-xs font-medium text-slate-400 line-through">
                                                ${formatUsd(product.oldPrice)}
                                            </span>
                                        ` : ''}
                                    </div>
                                    <div class="text-xs font-bold text-pink-600 mt-0.5">
                                        ${formatKhr(product.price)}
                                    </div>
                                </div>

                                ${isEditMode ? `
                                    <button onclick="openProductModal('${product.id}')" class="bg-amber-100 hover:bg-amber-500 text-amber-800 hover:text-white text-xs font-bold px-3 py-2 rounded-xl transition flex items-center gap-1.5 cursor-pointer">
                                        <i class="fa-solid fa-pen"></i>
                                        <span>កែតម្លៃ</span>
                                    </button>
                                ` : ''}
                            </div>

                            <!-- Action Button -->
                            <div class="mt-4">
                                ${isEditMode ? `
                                    <button onclick="openProductModal('${product.id}')" class="w-full py-2.5 rounded-2xl bg-amber-500 hover:bg-amber-600 text-white font-bold text-sm shadow-sm transition flex items-center justify-center gap-2 cursor-pointer">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                        <span>កែតម្លៃ / កែព័ត៌មានទំនិញ</span>
                                    </button>
                                ` : `
                                    <button onclick="addToCart('${product.id}')" class="w-full py-2.5 rounded-2xl bg-slate-900 hover:bg-gradient-to-r hover:from-indigo-600 hover:to-pink-500 text-white font-bold text-sm shadow-sm transition flex items-center justify-center gap-2 cursor-pointer">
                                        <i class="fa-solid fa-cart-plus"></i>
                                        <span>ដាក់ចូលកន្ត្រក</span>
                                    </button>
                                `}
                            </div>
                        </div>
                    </div>
                </div>
                `;
            }).join('');
        }

        // --- 9. ADD / EDIT / DELETE PRODUCT LOGIC ---
        function openProductModal(productId = null) {
            const modal = document.getElementById('productModal');
            const title = document.getElementById('productModalTitle');
            const form = document.getElementById('productForm');
            form.reset();

            if (productId) {
                const p = products.find(item => item.id === productId);
                if (!p) return;
                title.innerHTML = '<i class="fa-solid fa-pen-to-square"></i><span>កែប្រែទំនិញ និងតម្លៃ</span>';
                document.getElementById('prodId').value = p.id;
                document.getElementById('prodName').value = p.name;
                document.getElementById('prodPrice').value = p.price;
                document.getElementById('prodOldPrice').value = p.oldPrice || '';
                document.getElementById('prodCategory').value = p.category || '';
                document.getElementById('prodBadge').value = p.badge || '';
                document.getElementById('prodImageUrl').value = p.image || '';
                document.getElementById('prodDesc').value = p.desc || '';
                document.getElementById('prodImgPreview').src = p.image || 'https://placehold.co/200x200/e0e7ff/4f46e5?text=Nimol';
            } else {
                title.innerHTML = '<i class="fa-solid fa-plus-circle"></i><span>បន្ថែមទំនិញថ្មី</span>';
                document.getElementById('prodId').value = '';
                document.getElementById('prodImgPreview').src = 'https://placehold.co/200x200/e0e7ff/4f46e5?text=New';
            }

            updateLiveKhrPreview();
            modal.classList.remove('hidden');
            modal.classList.add('flex');
        }

        function closeProductModal() {
            const modal = document.getElementById('productModal');
            modal.classList.add('hidden');
            modal.classList.remove('flex');
        }

        function updateLiveKhrPreview() {
            const usd = document.getElementById('prodPrice').value;
            document.getElementById('liveKhrPreview').textContent = formatKhr(usd);
        }

        function previewImageUrl(url) {
            const preview = document.getElementById('prodImgPreview');
            if (url && url.trim().length > 5) {
                preview.src = url.trim();
            } else {
                preview.src = 'https://placehold.co/200x200/e0e7ff/4f46e5?text=Nimol';
            }
        }

        function handleImageUpload(event) {
            const file = event.target.files[0];
            if (!file) return;

            const reader = new FileReader();
            reader.onload = function(e) {
                // Resize image on canvas so LocalStorage stays lightweight
                const img = new Image();
                img.onload = function() {
                    const canvas = document.createElement('canvas');
                    const MAX_SIZE = 500;
                    let width = img.width;
                    let height = img.height;

                    if (width > height) {
                        if (width > MAX_SIZE) {
                            height *= MAX_SIZE / width;
                            width = MAX_SIZE;
                        }
                    } else {
                        if (height > MAX_SIZE) {
                            width *= MAX_SIZE / height;
                            height = MAX_SIZE;
                        }
                    }
                    canvas.width = width;
                    canvas.height = height;
                    const ctx = canvas.getContext('2d');
                    ctx.drawImage(img, 0, 0, width, height);
                    const compressedDataUrl = canvas.toDataURL('image/jpeg', 0.8);

                    document.getElementById('prodImageUrl').value = compressedDataUrl;
                    document.getElementById('prodImgPreview').src = compressedDataUrl;
                };
                img.src = e.target.result;
            };
            reader.readAsDataURL(file);
        }

        function saveProduct(e) {
            e.preventDefault();
            const id = document.getElementById('prodId').value;
            const name = document.getElementById('prodName').value.trim();
            const price = parseFloat(document.getElementById('prodPrice').value) || 0;
            const oldPriceVal = document.getElementById('prodOldPrice').value;
            const oldPrice = oldPriceVal ? parseFloat(oldPriceVal) : null;
            const category = document.getElementById('prodCategory').value.trim() || 'ទូទៅ';
            const badge = document.getElementById('prodBadge').value.trim();
            const image = document.getElementById('prodImageUrl').value.trim() || `https://placehold.co/600x600/e0e7ff/4f46e5?text=${encodeURIComponent(name)}`;
            const desc = document.getElementById('prodDesc').value.trim();

            if (id) {
                const idx = products.findIndex(p => p.id === id);
                if (idx !== -1) {
                    products[idx] = { ...products[idx], name, price, oldPrice, category, badge, image, desc };
                    showToast(`បានកែប្រែ "${name}" រួចរាល់!`);
                }
            } else {
                const newProduct = {
                    id: 'p_' + Date.now(),
                    name,
                    price,
                    oldPrice,
                    category,
                    badge,
                    image,
                    desc
                };
                products.unshift(newProduct);
                showToast(`បានបន្ថែមទំនិញថ្មី "${name}"!`);
            }

            try {
                localStorage.setItem('nimol_store_products', JSON.stringify(products));
            } catch (err) {
                showToast('ទំហំរូបភាពធំពេក សូមប្រើ Link រូបភាពជំនួសវិញ', 'error');
            }

            renderCategories();
            renderProducts();
            renderCart();
            closeProductModal();
        }

        // --- 10. CONFIRMATION MODAL FOR DELETE / RESET ---
        function confirmDeleteProduct(productId) {
            const product = products.find(p => p.id === productId);
            if (!product) return;

            document.getElementById('confirmTitle').textContent = 'លុបទំនិញនេះចេញ?';
            document.getElementById('confirmMessage').textContent = `តើអ្នកពិតជាចង់លុប "${product.name}" ចេញពីហាងមែនទេ?`;
            
            const actionBtn = document.getElementById('confirmActionBtn');
            actionBtn.onclick = () => {
                products = products.filter(p => p.id !== productId);
                cart = cart.filter(c => c.id !== productId);
                localStorage.setItem('nimol_store_products', JSON.stringify(products));
                localStorage.setItem('nimol_store_cart', JSON.stringify(cart));
                renderCategories();
                renderProducts();
                renderCart();
                closeConfirmModal();
                showToast('បានលុបទំនិញចេញរួចរាល់');
            };

            const modal = document.getElementById('confirmModal');
            modal.classList.remove('hidden');
            modal.classList.add('flex');
        }

        function openConfirmResetModal() {
            document.getElementById('confirmTitle').textContent = 'កំណត់ទិន្នន័យឡើងវិញ?';
            document.getElementById('confirmMessage').textContent = 'ការកែប្រែទាំងអស់នឹងត្រឡប់ទៅគំរូដើមវិញ។ តើអ្នកយល់ព្រមទេ?';
            
            const actionBtn = document.getElementById('confirmActionBtn');
            actionBtn.onclick = () => {
                localStorage.removeItem('nimol_store_info');
                localStorage.removeItem('nimol_store_products');
                localStorage.removeItem('nimol_store_cart');
                storeInfo = { ...DEFAULT_STORE_INFO };
                products = [...DEFAULT_PRODUCTS];
                cart = [];
                renderStoreInfo();
                renderCategories();
                renderProducts();
                renderCart();
                closeConfirmModal();
                showToast('បានកំណត់ហាងឡើងវិញទៅគំរូដើម!');
            };

            const modal = document.getElementById('confirmModal');
            modal.classList.remove('hidden');
            modal.classList.add('flex');
        }

        function closeConfirmModal() {
            const modal = document.getElementById('confirmModal');
            modal.classList.add('hidden');
            modal.classList.remove('flex');
        }

        // --- 11. SHOPPING CART LOGIC ---
        function toggleCartDrawer(open) {
            const drawer = document.getElementById('cartDrawer');
            if (open) {
                drawer.classList.remove('hidden');
                renderCart();
            } else {
                drawer.classList.add('hidden');
            }
        }

        function addToCart(productId) {
            const product = products.find(p => p.id === productId);
            if (!product) return;

            const existing = cart.find(item => item.id === productId);
            if (existing) {
                existing.qty += 1;
            } else {
                cart.push({ id: productId, qty: 1 });
            }

            localStorage.setItem('nimol_store_cart', JSON.stringify(cart));
            renderCart();
            showToast(`បានដាក់ "${product.name}" ចូលកន្ត្រក!`);
        }

        function updateCartQty(productId, delta) {
            const item = cart.find(c => c.id === productId);
            if (!item) return;
            item.qty += delta;
            if (item.qty <= 0) {
                cart = cart.filter(c => c.id !== productId);
            }
            localStorage.setItem('nimol_store_cart', JSON.stringify(cart));
            renderCart();
        }

        function renderCart() {
            const container = document.getElementById('cartItemsContainer');
            const badge = document.getElementById('cartCountBadge');
            const totalItemsEl = document.getElementById('cartTotalItems');
            const totalUsdEl = document.getElementById('cartTotalUsd');
            const totalKhrEl = document.getElementById('cartTotalKhr');

            // Sync cart with current products
            cart = cart.filter(c => products.some(p => p.id === c.id));

            let totalQty = 0;
            let totalUsd = 0;

            if (cart.length === 0) {
                container.innerHTML = `
                    <div class="text-center py-16">
                        <div class="w-16 h-16 rounded-full bg-slate-100 text-slate-400 flex items-center justify-center mx-auto mb-3 text-2xl">
                            <i class="fa-solid fa-basket-shopping"></i>
                        </div>
                        <p class="text-slate-600 font-bold">កន្ត្រកទំនិញនៅទំនេរ</p>
                        <p class="text-xs text-slate-400 mt-1">សូមជ្រើសរើសទំនិញដែលអ្នកពេញចិត្ត!</p>
                    </div>
                `;
            } else {
                container.innerHTML = cart.map(item => {
                    const p = products.find(prod => prod.id === item.id);
                    const subTotal = p.price * item.qty;
                    totalQty += item.qty;
                    totalUsd += subTotal;

                    return `
                        <div class="flex items-center gap-3.5 bg-slate-50 p-3 rounded-2xl border border-slate-200/70">
                            <img src="${p.image}" alt="${p.name}" class="w-16 h-16 rounded-xl object-cover shrink-0 bg-white">
                            <div class="flex-1 min-w-0">
                                <h5 class="text-sm font-bold text-slate-900 truncate">${p.name}</h5>
                                <p class="text-xs font-bold text-indigo-600 mt-0.5">${formatUsd(p.price)} <span class="text-slate-400 font-normal">(${formatKhr(p.price)})</span></p>
                                
                                <div class="flex items-center gap-2 mt-2">
                                    <button onclick="updateCartQty('${p.id}', -1)" class="w-7 h-7 rounded-lg bg-white border border-slate-200 hover:bg-slate-100 text-slate-700 flex items-center justify-center text-xs font-bold cursor-pointer">-</button>
                                    <span class="text-xs font-bold w-6 text-center">${item.qty}</span>
                                    <button onclick="updateCartQty('${p.id}', 1)" class="w-7 h-7 rounded-lg bg-white border border-slate-200 hover:bg-slate-100 text-slate-700 flex items-center justify-center text-xs font-bold cursor-pointer">+</button>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="text-sm font-extrabold text-slate-900">${formatUsd(subTotal)}</div>
                            </div>
                        </div>
                    `;
                }).join('');
            }

            badge.textContent = totalQty;
            totalItemsEl.textContent = `${totalQty} មុខ`;
            totalUsdEl.textContent = formatUsd(totalUsd);
            totalKhrEl.textContent = formatKhr(totalUsd);
        }

        function checkoutOrder() {
            if (cart.length === 0) {
                showToast('សូមជ្រើសរើសទំនិញដាក់ចូលកន្ត្រកជាមុនសិន!', 'error');
                return;
            }
            cart = [];
            localStorage.setItem('nimol_store_cart', JSON.stringify(cart));
            renderCart();
            toggleCartDrawer(false);
            showToast(`អរគុណ! ការបញ្ជាទិញពីហាង "${storeInfo.name}" ត្រូវបានបញ្ជូនរួចរាល់!`);
        }
    </script>
</body>
</html>
