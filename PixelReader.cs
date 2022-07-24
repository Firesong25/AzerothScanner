using System.Diagnostics;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Text;
using Utilities;

namespace Chopper
{
    internal class PixelReader
    {
        public static bool IsRunning { get; set; }
        static string needlePath = @"D:\Assets\vascodegama\signature.png";
        static string haystackPath = @"D:\Assets\vascodegama\screen.png";
        static string pixelStripPath = @"D:\Assets\vascodegama\addon_data.png";
        static Dictionary<Color, int> colorToInt = new Dictionary<Color, int>();
        static IntPtr WowHandle = IntPtr.Zero;
        static int width = 3768;
        static int height = 1936;
        static Rectangle targetArea = Rectangle.Empty;
        static Bitmap valuesColumn;

        public static async Task Pulse()
        {
            while (true)
            {
                GetColorsToInts();
                await Task.Delay(100);
            }
        }

        public static async Task GetColorsToInts()
        {
            Stopwatch sw = Stopwatch.StartNew();
            //Bitmap pixelStrip = new(pixelStripPath);
            Bitmap pixelStrip = GrabScreen.GetTargetArea(targetArea);
            try
            {
                pixelStrip.Save(pixelStripPath);
            }
            catch
            {
                LogMaker.Log($"addonStrip is in use");
            }
            int w = pixelStrip.Width;
            Color tmp0, tmp1;
            List<int> foundValues = new();

            int centerPoint = Convert.ToInt32(w / 2);
            for (int i = 1; i < pixelStrip.Height; i += 12)
            {
                tmp0 = pixelStrip.GetPixel(centerPoint, i);
                tmp1 = NormaliseColor(tmp0);

                if (colorToInt.ContainsKey(tmp1))
                {
                    foundValues.Add(colorToInt[tmp1]);
                }
            }

            Me.FoundValues = foundValues;

            StringBuilder wtf = new();
            foreach (int i in foundValues)
            {
                wtf.Append(i);
                if (i > 100)
                    break;
            }

            //LogMaker.Log($"{wtf}");


            Stopwatch readTimer = Stopwatch.StartNew();
            // check that we have valid data
            StringBuilder sb = new();
            for (int a = 0; a < 10; a++)
                sb.Append($"{foundValues[a]}, ");

            //LogMaker.Log($"{sb}");

            if (sb.ToString() == "0, 1, 2, 3, 4, 5, 6, 7, 8, 9, ")
            {
                wtf.Clear();
                foundValues.RemoveAt(0);
                // use the numbers
                Me.MapId = Convert.ToInt32($"{foundValues[10]}{foundValues[11]}{foundValues[12]}{foundValues[13]}");
                Me.ZoneId = Convert.ToInt32($"{foundValues[14]}{foundValues[15]}{foundValues[16]}{foundValues[17]}");
                Me.X = Convert.ToDouble($"{foundValues[18]}{foundValues[19]}{foundValues[20]}{foundValues[21]}") / 100;
                Me.Y = Convert.ToDouble($"{foundValues[22]}{foundValues[23]}{foundValues[24]}{foundValues[25]}") / 100;
                Me.Facing = Convert.ToDouble($"{foundValues[26]}{foundValues[27]}{foundValues[28]}{foundValues[29]}") / 100;
                Me.CorpseX = Convert.ToDouble($"{foundValues[30]}{foundValues[31]}{foundValues[32]}{foundValues[33]}") / 100;
                Me.CorpseY = Convert.ToDouble($"{foundValues[34]}{foundValues[35]}{foundValues[36]}{foundValues[37]}") / 100;

                var kt = foundValues[38];
                if (kt == 1)
                    Me.KillTarget = true;
                else
                    Me.KillTarget = false;

                var se = foundValues[39];
                if (se == 1)
                    Me.StopEverything = true;
                else
                    Me.StopEverything = false;

                var rp = foundValues[40];
                if (rp == 1)
                    Me.RecordPath = true;
                else
                    Me.RecordPath = false;

                var isValidTarget = foundValues[41];
                if (isValidTarget == 1)
                    Me.IsValidTarget = true;
                else
                    Me.IsValidTarget = false;

                Me.TargetId = Convert.ToInt32($"{foundValues[42]}{foundValues[43]}{foundValues[44]}{foundValues[45]}{foundValues[46]}{foundValues[47]}");
                Me.TargetGuid = Convert.ToInt32($"{foundValues[48]}{foundValues[49]}{foundValues[50]}{foundValues[51]}");
                Me.QuestOne = Convert.ToInt32($"{foundValues[52]}{foundValues[53]}{foundValues[54]}{foundValues[55]}{foundValues[56]}");
                Me.QuestTwo = Convert.ToInt32($"{foundValues[57]}{foundValues[58]}{foundValues[59]}{foundValues[60]}{foundValues[61]}");
                Me.QuestThree = Convert.ToInt32($"{foundValues[62]}{foundValues[63]}{foundValues[64]}{foundValues[65]}{foundValues[66]}");
                Me.QuestFour = Convert.ToInt32($"{foundValues[67]}{foundValues[68]}{foundValues[69]}{foundValues[70]}{foundValues[71]}");

                var ic = Convert.ToInt32($"{foundValues[72]}");
                if (ic == 1)
                    Me.InCombat = true;
                else
                    Me.InCombat = false;

                Me.Level = Convert.ToInt32($"{foundValues[73]}{foundValues[74]}{foundValues[75]}");
                Me.KeyToPress = Convert.ToInt32($"{foundValues[76]}");
                Me.Modifier = Convert.ToInt32($"{foundValues[77]}");
                int interactNeeded = Convert.ToInt32($"{foundValues[78]}");
                

                if (Me.TargetGuid != Me.InteractSpam)
                {
                    interactNeeded = 1;
                    Me.InteractSpam = Me.TargetGuid;
                    LogMaker.Log($"Killing {Me.TargetGuid}");
                }

                if (interactNeeded == 1)
                    Me.InteractNeeded = true;
                else
                    Me.InteractNeeded = false;

            }
            else
            {
                LogMaker.Log($"Failed to find 0, 1, 2, 3, 4, 5, 6, 7, 8, 9");
                WowHandle = new IntPtr(GrabScreen.FindWindow("GxWindowClass", "World of Warcraft"));
                if (WowHandle == IntPtr.Zero)
                    Application.Exit();
            }

            DateTime lastKeyPress = Me.LastKeyPress;
            Me.LastPixelRead = DateTime.Now;
            await Task.Delay(1);
        }

        static Color NormaliseColor(Color randomNoise)
        {
            int realR, realG, realB;

            if (randomNoise.R < 85)
                realR = 0;
            else if (randomNoise.R < 170)
                realR = 125;
            else
                realR = 255;

            if (randomNoise.G < 85)
                realG = 0;
            else if (randomNoise.G < 170)
                realG = 125;
            else
                realG = 255;

            if (randomNoise.B < 85)
                realB = 0;
            else if (randomNoise.B < 170)
                realB = 125;
            else
                realB = 255;

            return Color.FromArgb(1, realR, realG, realB);
        }


        [DllImport("User32.dll")]
        static extern int SetForegroundWindow(IntPtr hWnd);

        [DllImport("user32.dll", SetLastError = true)]
        static extern bool MoveWindow(IntPtr hWnd, int x, int y, int nWidth, int nHeight, bool bRepaint);

        public static void Init()
        {
            Stopwatch sw = Stopwatch.StartNew();
            if (IsRunning)
                return;
            int c = Convert.ToInt32(100 / 255);
            colorToInt[Color.FromArgb(1, 0, 0, 0)] = 0;
            colorToInt[Color.FromArgb(1, 255, 255, 255)] = 1;
            colorToInt[Color.FromArgb(1, 255, 0, 0)] = 2;
            colorToInt[Color.FromArgb(1, 0, 255, 0)] = 3;
            colorToInt[Color.FromArgb(1, 0, 0, 255)] = 4;
            colorToInt[Color.FromArgb(1, 0, 255, 255)] = 5;
            colorToInt[Color.FromArgb(1, 255, 0, 255)] = 6;
            colorToInt[Color.FromArgb(1, 255, 255, 0)] = 7;
            colorToInt[Color.FromArgb(1, 255, 125, 255)] = 8;
            colorToInt[Color.FromArgb(1, 255, 255, 125)] = 9;
            colorToInt[Color.FromArgb(1, 125, 125, 125)] = 10;

            WowHandle = new IntPtr(GrabScreen.FindWindow("GxWindowClass", "World of Warcraft"));

            if (WowHandle != IntPtr.Zero)
            {
                SetForegroundWindow(WowHandle);
                MoveWindow(WowHandle, 0, 0, width, height, true);
            }
            else
            {
                LogMaker.Log($"PixelReader.Init() failed to find WoW.");
                IsRunning = false;
                return;
            }

            Bitmap needle = new(needlePath);
            Bitmap haystack = CaptureMyScreen();
            // this is the area we will be screenshotting again and again
            targetArea = BmpFinder.SearchForOneBitmap(needle, haystack, 0.3);
            if (targetArea == Rectangle.Empty)
            {
                LogMaker.Log($"PixelReader.Init(): Failed to find signature pixels in {sw.ElapsedMilliseconds} ms.");
                IsRunning = false;
                return;
            }
            else
            {
                // magic number to provide a buffer
                targetArea.Height = height - targetArea.Y - 100;
                valuesColumn = GrabScreen.GetSectionFromImage(haystack, targetArea);
                //valuesColumn.Save(pixelStripPath);
                IsRunning = true;
                LogMaker.Log($"PixelReader.Init(): Found signature pixels in {sw.ElapsedMilliseconds} ms.");
            }
        }

        // https://www.c-sharpcorner.com/UploadFile/2d2d83/how-to-capture-a-screen-using-C-Sharp/
        public static Bitmap CaptureMyScreen()
        {
            try
            {
                //Creating a new Bitmap object
                Bitmap captureBitmap = new Bitmap(width, height, PixelFormat.Format32bppArgb);
                //Bitmap captureBitmap = new Bitmap(int width, int height, PixelFormat);
                //Creating a Rectangle object which will
                //capture our Current Screen
                Rectangle captureRectangle = Screen.AllScreens[0].Bounds;
                //Creating a New Graphics Object
                Graphics captureGraphics = Graphics.FromImage(captureBitmap);
                //Copying Image from The Screen
                captureGraphics.CopyFromScreen(captureRectangle.Left, captureRectangle.Top, 0, 0, captureRectangle.Size);
                //Saving the Image File 
                captureBitmap.Save(haystackPath, ImageFormat.Jpeg);
                return captureBitmap;

            }
            catch (Exception ex)
            {
                return new Bitmap(width, height, PixelFormat.Format32bppArgb);
                LogMaker.Log($"{ex.Message}");
            }
        }
    }
}
