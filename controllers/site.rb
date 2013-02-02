# encoding: utf-8

get "/" do
  @arms_centers = [
      {
          :name => "sword_master",
          :english => "Sword Master",
          :russian => "Мастер меча"
      },
      {
          :name => "sharpest_spear",
          :english => "Sharpest Spear",
          :russian => "Острое копьё"
      },
      {
          :name => "heavy_axe",
          :english => "Heavy Axe",
          :russian => "Тяжёлый топор"
      },
      {
          :name => "heavy_infantry",
          :english => "Heavy Infantry",
          :russian => "Тяжёлая пехота"
      },
      {
          :name => "elite_marksman",
          :english => "Elite Marksman",
          :russian => "Меткий стрелок"
      },
      {
          :name => "skilled_equestrian",
          :english => "Skilled Equestrian",
          :russian => "Конный спорт"
      }
  ]

  @max_cave_count = 2

  @who_in_caves = [
      {
          :value => "",
          :english => "nothing",
          :russian => "Никого"
      },
      {
          :value => "swordsman",
          :english => "Swordsman",
          :russian => "Мечник"
      },
      {
          :value => "spearman",
          :english => "Spearman",
          :russian => "Копейщик"
      },
      {
          :value => "axeman",
          :english => "Axeman",
          :russian => "Топорщик"
      },
      {
          :value => "archer",
          :english => "archer",
          :russian => "Лучник"
      },
      {
          :value => "cavalry",
          :english => "Cavalry",
          :russian => "Кавалерия"
      },
      {
          :value => "lancer",
          :english => "Lancer",
          :russian => "Лансер"
      },
      {
          :value => "axerider",
          :english => "Axerider",
          :russian => "Кон. Топор."
      }
  ]

  #noinspection RubyResolve
  slim :index
end

post "/result" do
  result = true

  coefficient = {
      :main => 6,
      :c_main => 4.4,
      :k_main => 6.5
  }

  arms_center_level = {
      :sword_master => (20 * (params[:sword_master].to_i)) / 100,
      :sharpest_spear => (34 * (params[:sharpest_spear].to_i)) / 100,
      :heavy_axe => (56 * (params[:heavy_axe].to_i)) / 100,
      :heavy_infantry => (params[:heavy_infantry].to_i + 0.0 - 1) / 100 + 0.01,
      :elite_marksman => (94 * (params[:elite_marksman].to_i)) / 100,
      :skilled_equestrian => (params[:skilled_equestrian].to_i + 0.0 - 1) / 100 + 0.01,
  }

  who_in_cave = "#{params[:who_in_cave][0]}#{params[:who_in_cave][1]}"

  @results = case who_in_cave
               when "swordsman" then
                 power = {
                     :main => (20 * params[:who_count][0].to_i) * coefficient[:main],
                     :archer => (20 * params[:who_count][0].to_i) * coefficient[:c_main]
                 }

                 spearman = ((power[:main] / ((44 * arms_center_level[:heavy_infantry] + 44) + arms_center_level[:sharpest_spear])) + 1).floor
                 archer = ((power[:archer] / ((134 * arms_center_level[:heavy_infantry] + 134) + arms_center_level[:elite_marksman])) + 1).floor
                 lancer = ((power[:main] / (339 * arms_center_level[:skilled_equestrian] + 339)) + 1).floor

                 [
                     {
                         :who => "мечник",
                         :count => spearman
                     },
                     {
                         :who => "лучник",
                         :count => archer
                     },
                     {
                         :who => "лансер",
                         :count => lancer
                     }
                 ]
               when "spearman" then
                 power = {
                     :main => (34 * params[:who_count][0].to_i) * coefficient[:main],
                     :archer => (34 * params[:who_count][0].to_i) * coefficient[:c_main],
                     :spearman => (45 * params[:who_count][0].to_i) * coefficient[:k_main]
                 }

                 axeman = (power[:main] / ((73 * arms_center_level[:heavy_infantry] + 73) + arms_center_level[:heavy_axe])).floor + 1
                 archer = (power[:archer] / ((134 * arms_center_level[:heavy_infantry] + 134) + arms_center_level[:elite_marksman])).floor + 1
                 axerider = (power[:spearman] / (567 * arms_center_level[:skilled_equestrian] + 567)).floor + 1

                 [
                     {
                         :who => "топорщик",
                         :count => axeman
                     },
                     {
                         :who => "лучник",
                         :count => archer
                     },
                     {
                         :who => "кон. топор.",
                         :count => axerider
                     }
                 ]
               when "axeman" then
                 power = {
                     :main => (56 * params[:who_count][0].to_i) * coefficient[:main],
                     :archer => (56 * params[:who_count][0].to_i) * coefficient[:c_main],
                     :spearman => (73 * params[:who_count][0].to_i) * coefficient[:k_main],
                 }

                 swordsman = (power[:main] / ((26 * arms_center_level[:heavy_infantry] + 26) + arms_center_level[:sword_master])).floor + 1
                 archer = (power[:archer] / ((134 * arms_center_level[:heavy_infantry] + 134) + arms_center_level[:elite_marksman])).floor + 1
                 cavalry = (power[:main] / (205 * arms_center_level[:skilled_equestrian] + 205)).floor + 1

                 [
                     {
                         :who => "мечник",
                         :count => swordsman
                     },
                     {
                         :who => "лучник",
                         :count => archer
                     },
                     {
                         :who => "кавалерия",
                         :count => cavalry
                     },
                 ]
               when "archer" then
                 power = {
                     :main => (94 * params[:who_count][0].to_i) * coefficient[:main]
                 }

                 cavalry = (power[:main] / (222 * arms_center_level[:skilled_equestrian] + 222)).floor + 1
                 lancer = (power[:main] / (368 * arms_center_level[:skilled_equestrian] + 368)).floor + 1
                 axerider = (power[:main] / (614 * arms_center_level[:skilled_equestrian] + 614)).floor + 1

                 [
                     {
                         :who => "кавалерия",
                         :count => cavalry
                     },
                     {
                         :who => "лансер",
                         :count => lancer
                     },
                     {
                         :who => "кон. топор.",
                         :count => axerider
                     },
                 ]
               when "cavalryaxeman", "axemancavalry" then
                 power = case who_in_cave.to_s
                           when "cavalryaxeman"
                             {
                                 :main => [
                                     156 * params[:who_count][0].to_i,
                                     56 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "axemancavalry" then
                             {
                                 :main => [
                                     156 * params[:who_count][1].to_i,
                                     56 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             result = false
                         end

                 swordsman = (power[:main] / ((26 * arms_center_level[:heavy_infantry] + 26) + arms_center_level[:sword_master])).floor + 1

                 [
                     {
                         :who => "мечник",
                         :count => swordsman
                     }
                 ]
               when "spearmanlancer", "lancerspearman" then
                 power = case who_in_cave.to_s
                           when "spearmanlancer"
                             {
                                 :main => [
                                     34 * params[:who_count][0].to_i,
                                     258 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "lancerspearman" then
                             {
                                 :main => [
                                     34 * params[:who_count][1].to_i,
                                     258 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             #noinspection RubyResolve
                             result = false
                         end

                 axeman = (power[:main] / ((73 * arms_center_level[:heavy_infantry] + 73) + arms_center_level[:heavy_axe])).floor + 1

                 [
                     {
                         :who => "лучник",
                         :count => axeman
                     }
                 ]
               when "axeriderlancer", "lanceraxerider" then
                 power = case who_in_cave.to_s
                           when "axeriderlancer"
                             {
                                 :main => [
                                     430 * params[:who_count][0].to_i,
                                     258 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "lanceraxerider" then
                             {
                                 :main => [
                                     430 * params[:who_count][1].to_i,
                                     258 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             #noinspection RubyResolve
                             result = false
                         end

                 axeman = (power[:main] / ((79 * arms_center_level[:heavy_infantry] + 79) + arms_center_level[:heavy_axe])).floor + 1

                 [
                     {
                         :who => "топорщик",
                         :count => axeman
                     }
                 ]
               when "axemanswordsman", "swordsmanaxeman" then
                 power = case who_in_cave.to_s
                           when "axemanswordsman"
                             {
                                 :main => [
                                     56 * params[:who_count][0].to_i,
                                     20 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "swordsmanaxeman" then
                             {
                                 :main => [
                                     56 * params[:who_count][1].to_i,
                                     20 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             #noinspection RubyResolve
                             result = false
                         end

                 archer = (power[:main] / ((134 * arms_center_level[:heavy_infantry] + 134) + arms_center_level[:elite_marksman])).floor + 1

                 [
                     {
                         :who => "лучник",
                         :count => archer
                     }
                 ]
               when "cavalryswordsman", "swordsmancavalry" then
                 power = case who_in_cave.to_s
                           when "cavalryswordsman"
                             {
                                 :main => [
                                     156 * params[:who_count][0].to_i,
                                     20 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "swordsmancavalry" then
                             {
                                 :main => [
                                     156 * params[:who_count][1].to_i,
                                     20 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             #noinspection RubyResolve
                             result = false
                         end

                 spearman = (power[:main] / ((44 * arms_center_level[:heavy_infantry] + 44) + arms_center_level[:sharpest_spear])).floor + 1

                 [
                     {
                         :who => "копейщик",
                         :count => spearman
                     }
                 ]
               when "archerlancer", "lancerarcher" then
                 power = case who_in_cave.to_s
                           when "archerlancer"
                             {
                                 :main => [
                                     94 * params[:who_count][0].to_i,
                                     258 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "lancerarcher" then
                             {
                                 :main => [
                                     94 * params[:who_count][1].to_i,
                                     258 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             result = false
                         end

                 axerider = (power[:main] / (614 * arms_center_level[:skilled_equestrian] + 614)).floor + 1
                 lancer = (power[:main] / (283 * arms_center_level[:skilled_equestrian] + 283)).floor * 2 + 1

                 [
                     {
                         :who => "кон. топор.",
                         :count => axerider
                     },
                     {
                         :who => "лансер",
                         :count => lancer
                     }
                 ]
               when "axemanspearman", "spearmanaxeman" then
                 power = case who_in_cave.to_s
                           when "axemanspearman"
                             {
                                 :main => [
                                     56 * params[:who_count][0].to_i,
                                     34 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "spearmanaxeman" then
                             {
                                 :main => [
                                     56 * params[:who_count][1].to_i,
                                     34 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             result = false
                         end

                 archer = (power[:main] / (134 * arms_center_level[:heavy_infantry] + 134) + arms_center_level[:elite_marksman]).floor + 1


                 [
                     {
                         :who => "лучник",
                         :count => archer
                     }
                 ]

               when "lanceraxeman", "axemanlancer" then
                 power = case who_in_cave.to_s
                           when "lanceraxeman"
                             {
                                 :main => [
                                     258 * params[:who_count][0].to_i,
                                     56 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "axemanlancer" then
                             {
                                 :main => [
                                     258 * params[:who_count][1].to_i,
                                     56 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             result = false
                         end

                 swordsman = (power[:main] / ((25 * arms_center_level[:heavy_infantry] + 25) + arms_center_level[:sword_master])).floor + 1

                 [
                     {
                         :who => "мечник",
                         :count => swordsman
                     }
                 ]
               when "swordsmanlancer", "lancerswordsman" then
                 power = case who_in_cave.to_s
                           when "swordsmanlancer"
                             {
                                 :main => [
                                     20 * params[:who_count][0].to_i,
                                     258 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "lancerswordsman" then
                             {
                                 :main => [
                                     20 * params[:who_count][1].to_i,
                                     258 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             result = false
                         end

                 spearman = (power[:main] / ((44 * arms_center_level[:heavy_infantry] + 44) + arms_center_level[:sharpest_spear])).floor + 1

                 [
                     {
                         :who => "копейщик",
                         :count => spearman
                     }
                 ]
               when "spearmanswordsman", "swordsmanspearman" then
                 power = case who_in_cave.to_s
                           when "spearmanswordsman"
                             {
                                 :main => [
                                     34 * params[:who_count][0].to_i,
                                     20 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "swordsmanspearman" then
                             {
                                 :main => [
                                     34 * params[:who_count][1].to_i,
                                     20 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             result = false
                         end

                 archer = (power[:main] / (134 * arms_center_level[:heavy_infantry] + 134) + arms_center_level[:elite_marksman]).floor + 1

                 [
                     {
                         :who => "лучник",
                         :count => archer
                     }
                 ]
               when "cavalryspearman", "spearmancavalry" then
                 power = case who_in_cave.to_s
                           when "cavalryspearman"
                             {
                                 :main => [
                                     190 * params[:who_count][0].to_i,
                                     34 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "spearmancavalry" then
                             {
                                 :main => [
                                     190 * params[:who_count][1].to_i,
                                     34 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             result = false
                         end

                 axeman = (power[:main] / ((79 * arms_center_level[:heavy_infantry] + 79) + arms_center_level[:heavy_axe])).floor + 1

                 [
                     {
                         :who => "топорщик",
                         :count => axeman
                     }
                 ]

               when "lancercavalry", "cavalrylancer" then
                 power = case who_in_cave.to_s
                           when "lancercavalry"
                             {
                                 :main => [
                                     258 * params[:who_count][0].to_i,
                                     156 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "cavalrylancer" then
                             {
                                 :main => [
                                     258 * params[:who_count][1].to_i,
                                     156 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             #noinspection RubyResolve
                             result = false
                         end

                 spearman = (power[:main] / ((48 * arms_center_level[:heavy_infantry] + 48) + arms_center_level[:sharpest_spear])).floor + 1

                 [
                     {
                         :who => "копейщик",
                         :count => spearman
                     }
                 ]


               when "cavalryarcher", "archercavalry" then
                 power = case who_in_cave.to_s
                           when "cavalryarcher"
                             {
                                 :main => [
                                     156 * params[:who_count][0].to_i,
                                     94 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "archercavalry" then
                             {
                                 :main => [
                                     156 * params[:who_count][1].to_i,
                                     94 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             #noinspection RubyResolve
                             result = false
                         end

                 lancer = (power[:main] / (368 * arms_center_level[:skilled_equestrian] + 368)).floor + 1
                 axerider = (power[:main] / (614 * arms_center_level[:skilled_equestrian] + 614)).floor + 1


                 [
                     {
                         :who => "кон. топор.",
                         :count => axerider
                     },
                     {
                         :who => "лансер",
                         :count => lancer
                     }
                 ]


               when "cavalryaxerider", "axeridercavalry" then
                 power = case who_in_cave.to_s
                           when "cavalryaxerider"
                             {
                                 :main => [
                                     156 * params[:who_count][0].to_i,
                                     430 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "axeridercavalry" then
                             {
                                 :main => [
                                     156 * params[:who_count][1].to_i,
                                     430 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             result = false
                         end

                 spearman = ((power[:main] / ((28 * arms_center_level[:heavy_infantry] + 28) + arms_center_level[:sharpest_spear])) + 1).floor

                 [
                     {
                         :who => "мечник",
                         :count => spearman
                     }
                 ]

               when "spearmanarcher", "archerspearman" then
                 power = case who_in_cave.to_s
                           when "spearmanarcher"
                             {
                                 :main => [
                                     44 * params[:who_count][0].to_i,
                                     94 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "archerspearman" then
                             {
                                 :main => [
                                     44 * params[:who_count][1].to_i,
                                     94 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             #noinspection RubyResolve
                             result = false
                         end

                 axerider = (power[:main] / (591 * arms_center_level[:skilled_equestrian] + 591)).floor + 1

                 [
                     {
                         :who => "кон. топор.",
                         :count => axerider
                     }
                 ]

               when "spearmanaxerider", "axeriderspearman" then
                 power = case who_in_cave.to_s
                           when "spearmanaxerider"
                             {
                                 :main => [
                                     34 * params[:who_count][0].to_i,
                                     430 * params[:who_count][1].to_i
                                 ].max * coefficient[:main]
                             }
                           when "axeriderspearman" then
                             {
                                 :main => [
                                     34 * params[:who_count][1].to_i,
                                     430 * params[:who_count][0].to_i
                                 ].max * coefficient[:main]
                             }
                           else
                             result = false
                         end

                 axeman = (power[:main] / ((79 * arms_center_level[:heavy_infantry] + 79) + arms_center_level[:heavy_axe])).floor + 1

                 [
                     {
                         :who => "топорщик",
                         :count => axeman
                     }
                 ]
               else
                 result = false
             end
  case result
    when true then
      slim :result
    else
      slim :error
  end
end

get "/about" do
  slim :about
end

get "/donate" do
  slim :donate
end

get "/contacts" do
  slim :contacts
end

get "/faq" do
  slim :faq
end
