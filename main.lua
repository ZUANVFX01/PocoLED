require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "layout"

activity.setTheme(R.AndLua18)
activity.setContentView(loadlayout(layout))
activity.ActionBar.hide()

function Statusbarcolor(a)
  if Build.VERSION.SDK_INT >= 21 then
    activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(a);
  end
end

Statusbarcolor(0xff7B83FF)


btn_basic_effects.onClick = function()
  local items = {"Breathing", "Collision", "Skyline", "Flower", "Back"}

  AlertDialog.Builder(this)
  .setTitle("Basic Effects")
  .setItems(items, function(dialog, which)
    local selected = items[which + 1] -- Lua index mulai dari 1
    if selected == "Breathing" then
      -- aksi untuk Breathing
      print("Breathing selected")
     elseif selected == "Collision" then
      print("Collision selected")
     elseif selected == "Skyline" then
      print("Skyline selected")
     elseif selected == "Flower" then
      print("Flower selected")
     elseif selected == "Back" then
      dialog.dismiss()
    end
  end)
  .show()
end



btn_basic_effects.onClick = function()
  local items = {"Breathing", "Collision", "Skyline", "Flower", "Dynamic", "Back"}

  AlertDialog.Builder(this)
  .setTitle("Basic Effects")
  .setItems(items, function(dialog, which)
    local selected = items[which + 1]

    if selected == "Breathing" then
      os.execute("su -c 'echo 1 > /sys/class/leds/aw22xxx_led/hwen'")
      os.execute("su -c 'echo 2 > /sys/class/leds/aw22xxx_led/effect'")
      os.execute("su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'")
     elseif selected == "Collision" then
      os.execute("su -c 'echo 1 > /sys/class/leds/aw22xxx_led/hwen'")
      os.execute("su -c 'echo 3 > /sys/class/leds/aw22xxx_led/effect'")
      os.execute("su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'")
     elseif selected == "Skyline" then
      os.execute("su -c 'echo 1 > /sys/class/leds/aw22xxx_led/hwen'")
      os.execute("su -c 'echo 4 > /sys/class/leds/aw22xxx_led/effect'")
      os.execute("su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'")
     elseif selected == "Flower" then
      os.execute("su -c 'echo 1 > /sys/class/leds/aw22xxx_led/hwen'")
      os.execute("su -c 'echo 5 > /sys/class/leds/aw22xxx_led/effect'")
      os.execute("su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'")
     elseif selected == "Back" then
     elseif selected == "Dynamic" then
      os.execute("su -c 'echo none > /sys/class/leds/aw22xxx_led/trigger'")
      os.execute("su -c 'echo 1 > /sys/class/leds/aw22xxx_led/hwen'")
      os.execute("su -c 'echo \"0 255 0\" > /sys/class/leds/aw22xxx_led/task0'")
      os.execute("su -c 'echo 200 > /sys/class/leds/aw22xxx_led/brightness'")
     elseif selected == "Back" then
      dialog.dismiss()
    end
  end)
  .show()
end

-- Fungsi bantu untuk mengaktifkan LED (jika perlu)
function enable_led()
  os.execute("su -c 'echo 1 > /sys/class/leds/aw22xxx_led/hwen'")
end

-- Aksi tombol Static Colors
btn_static_colors.onClick = function()
  local items = {"Red", "Green", "Blue", "Yellow", "Custom RGB", "Back"}

  AlertDialog.Builder(this)
  .setTitle("Static Colors")
  .setItems(items, function(dialog, which)
    local selected = items[which + 1]

    if selected == "Red" then
      enable_led()
      os.execute("su -c 'echo 8 > /sys/class/leds/aw22xxx_led/effect'")
      os.execute("su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'")

     elseif selected == "Green" then
      enable_led()
      os.execute("su -c 'echo 9 > /sys/class/leds/aw22xxx_led/effect'")
      os.execute("su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'")

     elseif selected == "Blue" then
      enable_led()
      os.execute("su -c 'echo 10 > /sys/class/leds/aw22xxx_led/effect'")
      os.execute("su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'")

     elseif selected == "Yellow" then
      enable_led()
      os.execute("su -c 'echo \"255 255 0\" > /sys/class/leds/aw22xxx_led/task0'")



     elseif selected == "Custom RGB" then
      -- Buat dialog input manual RGB
      local input = EditText(this)
      input.setHint("Contoh: 120 200 255")

      AlertDialog.Builder(this)
      .setTitle("Masukkan RGB")
      .setView(input)
      .setPositiveButton("OK", function()
        local rgb = input.Text
        enable_led()
        os.execute("su -c 'echo \"" .. rgb .. "\" > /sys/class/leds/aw22xxx_led/task0'")
      end)
      .setNegativeButton("Batal", nil)
      .show()

     elseif selected == "Back" then
      dialog.dismiss()
    end
  end)
  .show()
end

-- Execute shell command with root
function exec(cmd)
  local p = io.popen("su -c '"..cmd.."'")
  local result = p:read("*a")
  p:close()
  return result
end

-- Get system info
function get_system_info()
  local effect = (exec("cat /sys/class/leds/aw22xxx_led/effect") or "N/A"):gsub("\n", "")
  local cfg = (exec("cat /sys/class/leds/aw22xxx_led/cfg") or "N/A"):gsub("\n", "")
  local brightness = (exec("cat /sys/class/leds/aw22xxx_led/brightness") or "N/A"):gsub("\n", "")
  local imax = (exec("cat /sys/class/leds/aw22xxx_led/imax") or "N/A"):gsub("\n", "")
  local rgb = (exec("cat /sys/class/leds/aw22xxx_led/rgb") or "N/A"):gsub("\n", "")

  return string.format([[
• Effect      : %s
• Config      : %s
• Brightness  : %s
• IMAX        : %s
• RGB         : %s
]], effect, cfg, brightness, imax, rgb)
end

-- Update system info display
function updateSystemInfo()
  local success, err = pcall(function()
    local info = get_system_info()
    txt_system_info.setText(info)
  end)

  if not success then
    txt_system_info.setText("Error getting system info:\n"..err)
  end
end

-- Refresh button click handler
btn_refresh_info.onClick = function()
  updateSystemInfo()
  Toast.makeText(activity, "System info refreshed", Toast.LENGTH_SHORT).show()
end

-- Called when activity is created
function onCreate()
  -- Load your UI layout here
  -- ...

  -- Load system info immediately
  updateSystemInfo()

  -- Optional: Add a slight delay to ensure UI is fully loaded
  Handler().postDelayed(Runnable({
    run = function()
      updateSystemInfo()
    end
  }), 300)
end

-- Called when activity becomes visible
function onStart()
  -- Refresh data each time the activity becomes visible
  updateSystemInfo()
end



-- Matikan LED dengan root
function led_off()
  os.execute("su -c 'echo 0 > /sys/class/leds/aw22xxx_led/hwen'")
  print("LED Turned off")
end

-- Keluar aplikasi
function exit_app()
  activity.finish()
end

-- Hubungkan tombol ke fungsi
btn_led_off.onClick = led_off
btn_exit.onClick = exit_app

-- Fungsi untuk meminta input dan mengubah pengaturan LED
function custom_settings()
  local items = {"Set Brightness", "Set Current Level", "Back"}

  -- Membuat dialog untuk memilih setting
  local dialog = AlertDialog.Builder(this)
  .setTitle("Custom Settings")
  .setItems(items, function(dialog, which)
    local selected = items[which + 1]

    if selected == "Set Brightness" then
      -- Prompt untuk brightness
      prompt_for_input("Enter brightness (0-255)", function(brightness)
        if brightness then
          os.execute("su -c 'echo " .. brightness .. " > /sys/class/leds/aw22xxx_led/brightness'")
          Toast.makeText(this, "Brightness set to " .. brightness, Toast.LENGTH_SHORT).show()
        end
      end)



     elseif selected == "Set Current Level" then
      -- Prompt untuk current level
      prompt_for_input("Enter level number (0-b)", function(imax)
        if imax then
          os.execute("su -c 'echo " .. imax .. " > /sys/class/leds/aw22xxx_led/imax'")
          Toast.makeText(this, "Current level set", Toast.LENGTH_SHORT).show()
        end
      end)

     elseif selected == "Back" then
      dialog.dismiss()
    end
  end)
  .show()
end

-- Fungsi untuk menampilkan dialog input dan mengembalikan hasilnya
function prompt_for_input(title, callback)
  local layout = LinearLayout(this)
  layout.setOrientation(1)
  layout.setPadding(50, 40, 50, 10)

  local infoText = TextView(this)
  infoText.setTextSize(14)
  infoText.setTextColor(0xFF888888)

  if title == "Enter level number (0-b)" then
    local handle = io.popen("su -c 'cat /sys/class/leds/aw22xxx_led/imax | grep AW22XXX_IMAX'")
    local levels = handle:read("*a") or ""
    handle:close()
    infoText.setText("Available current levels:\n" .. levels)
  end

  local editText = EditText(this)
  editText.setHint(title)

  layout.addView(infoText)
  layout.addView(editText)

  local dialog = AlertDialog.Builder(this)
  .setTitle(title)
  .setView(layout)
  .setPositiveButton("OK", function(dialog)
    local input = editText.getText().toString()
    callback(input)
  end)
  .setNegativeButton("Cancel", function(dialog)
    callback(nil)
  end)
  .show()
end

-- Aksi tombol Custom Settings
btn_custom_settings.onClick = function()
  custom_settings()
end

-- Fungsi deteksi root
function check_root()
  local p = io.popen("su -c id")
  if p then
    local result = p:read("*a")
    p:close()
    if result:match("uid=0") then
      return true
    end
  end
  return false
end

-- Fungsi untuk menampilkan dialog dan tutup aplikasi
function showRootFailDialog()
  AlertDialog.Builder(this)
  .setTitle("Root Access Required")
  .setMessage("This app needs root access.\nThe app will close in 5 seconds.")
  .setCancelable(false)
  .setPositiveButton("Exit", function()
    activity.finish()
  end)
  .show()

  Handler().postDelayed(function()
    activity.finish()
  end, 5000)
end

-- Deteksi saat aplikasi mulai
if not check_root() then
  showRootFailDialog()
 else
  -- lanjutkan aplikasi di sini
end