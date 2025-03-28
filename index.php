<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SweetTooth</title>
    <link rel="shortcut icon" type="image" href="./image/logo.png">
    <link rel="stylesheet" href="style.css">
    <!-- bootstrap links -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    <!-- bootstrap links -->
    <!-- fonts links -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Uchen&display=swap" rel="stylesheet">
    <!-- fonts links -->
    <!-- icons links -->
    <link href='https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css' rel='stylesheet'>
    <!-- icons links -->
    <!-- animation links -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <!-- animation links -->
</head>
<body>
    <script>
        // 加载 header
        fetch("header.html")
            .then(response => response.text())
            .then(data => {
                document.getElementById("header").innerHTML = data;
                highlightCurrentPage(); // 确保 header 加载后再调用高亮函数
            });
    
        // 加载 footer
        fetch("footer.html")
            .then(response => response.text())
            .then(data => {
                document.getElementById("footer").innerHTML = data;
            });
    
        // 高亮当前页面的导航项
        function highlightCurrentPage() {
            const path = window.location.pathname.split("/").pop(); // 获取当前页面文件名
            let navItem = null;
    
            switch (path) {
                case "index.php":
                case "": // 处理默认首页
                    navItem = document.getElementById("nav-home");
                    break;
                case "gallery.html":
                    navItem = document.getElementById("nav-gallery");
                    break;
                case "about.html":
                    navItem = document.getElementById("nav-about");
                    break;
                case "contact.html":
                    navItem = document.getElementById("nav-contact");
                    break;
            }
    
            if (navItem) {
                navItem.classList.add("active");
            }
        }
    </script>
    <div id="header"></div> 
    <div class="all-content">
        
        <!-- home section -->
        <div class="home">
            <div class="content" data-aos="zoom-out-right">
                <h3>Sweet Lovers'
                    <br>Paradise
                </h3>
                <h2>We have <span class="changecontent"></span></h2>
                <p>Stressed spelled backward is desserts!
                    <br>Life is short, eat dessert first!
                </p>
                <a href="product.php" class="btn">Order Now</a>
            </div>
            <div class="img"  data-aos="zoom-out-left">
                <img src="./image/background.png" alt="">
            </div>
        </div>
        <!-- home section end -->

      <!-- top cards -->
      <div class="container" id="box"    data-aos="fade-up"
      data-aos-duration="1500">
        <div class="row">
            <div class="col-md-4 py-3 py-md-0">
                <div class="card">
                    <img src="./image/box1.jpg" alt="">
                </div>
            </div>
            <div class="col-md-4 py-3 py-md-0">
                <div class="card">
                    <img src="./image/box2.jpg" alt="">
                </div>
            </div>
            <div class="col-md-4 py-3 py-md-0">
                <div class="card">
                    <img src="./image/box3.jpg" alt="">
                </div>
            </div>
        </div>
      </div>
      <!-- top cards end -->

      <!-- banner -->
        <div class="banner"    data-aos="fade-up"
        data-aos-duration="1500">
            <div class="content">
                <h3>Delicious Dessert</h3>
                <h2>UPTO 50% OFF</h2>
                <p>Buy more Save more</p>
                <div id="btnorder" onclick="window.location.href='product.php?sort=promotion'"><button>Order Now</button></div>
            </div>
            <div class="img">
                <img src="./image/banner-background.png" alt="">
            </div>
        </div>
      <!-- banner end -->

      <!-- product cards -->
      <section id="product-cards">
    <div class="container">
        <h1>PRODUCT</h1>
        <div class="row" id="random-cakes">
           <!-- Product show at here -->
           <div class="card view-more">
            </div>
        </div>
    
    </div>
</section>

<script>
document.addEventListener("DOMContentLoaded", function() {
    fetch('fetch_cakes.php')
        .then(response => response.json())
        .then(data => {
            let html = "";
            data.forEach(cake => {
                html += `
                    <div class="col-md-3">
                        <div class="card">
                            <div class="overlay"></div>
                            <img src="${cake.image}" alt="${cake.name}">
                            <div class="card-body">
                                <h3>${cake.name}</h3>
                                <p>${cake.description}</p>
                                <h6>RM${cake.price} <span><button>Add Cart</button></span></h6>
                            </div>
                        </div>
                    </div>`;
            });

            // 添加 "View More" 按钮
            html += `
                <div class="col-md-3">
                    <div class="card view-more">
                        <a href="product.php" class="view-more-btn">View More</a>
                    </div>
                </div>`;

            document.getElementById("random-cakes").innerHTML = html;
        })
        .catch(error => console.error("Error loading cakes:", error));
});

</script>


      <!-- product cards end-->


      <!-- gallary -->
      <section id="gallary"    data-aos="fade-up"
      data-aos-duration="1500">
        <div class="container">
            <h1>OUR GALLARY</h1>
            <div class="row" style="margin-top: 30px;">
                <div class="col-md-4 py-3 py-md-0">
                    <div class="card">
                        <div class="overlay">
                            <h3 class="text-center">Donuts</h3>
                        </div>
                        <img src="./image/o1.png" alt="">
                    </div>
                </div>
                <div class="col-md-4 py-3 py-md-0">
                    <div class="card">
                        <div class="overlay">
                            <h3 class="text-center">Ice Cream</h3>
                        </div>
                        <img src="./image/o2.png" alt="">
                    </div>
                </div>
                <div class="col-md-4 py-3 py-md-0">
                    <div class="card">
                        <div class="overlay">
                            <h3 class="text-center">Cup Cake</h3>
                        </div>
                        <img src="./image/o3.png" alt="">
                    </div>
                </div>
            </div>


            <div class="row" style="margin-top: 30px;"    data-aos="fade-up"
            data-aos-duration="1500">
                <div class="col-md-4 py-3 py-md-0">
                    <div class="card">
                        <div class="overlay">
                            <h3 class="text-center">Delicious Cake</h3>
                        </div>
                        <img src="./image/o4.png" alt="">
                    </div>
                </div>
                <div class="col-md-4 py-3 py-md-0">
                    <div class="card">
                        <div class="overlay">
                            <h3 class="text-center">Chocolate Cake</h3>
                        </div>
                        <img src="./image/o5.png" alt="">
                    </div>
                </div>
                <div class="col-md-4 py-3 py-md-0">
                    <div class="card">
                        <div class="overlay">
                            <h3 class="text-center">Slice Cake</h3>
                        </div>
                        <img src="./image/o6.png" alt="">
                    </div>
                </div>
            </div>
        </div>
      </section>
      <!-- gallary -->



      <!-- about -->
      <div class="container" id="about"    data-aos="fade-up"
      data-aos-duration="1500">
        <h1>ABOUT US</h1>
        <div class="row">
            <div class="col-md-6 py-3 py-md-0">
                <div class="card">
                    <img src="./image/about.png" alt="">
                </div>
            </div>
            <div class="col-md-6 py-3 py-md-0">
                    <p>Lorem ipsum dolor sit amet consectetur, adipisicing elit. Molestias explicabo nulla dicta perferendis cupiditate autem assumenda unde fugit? Corrupti ipsa fugiat similique voluptate temporibus, cupiditate cumque iusto? Necessitatibus suscipit qui molestias odit ad aspernatur harum aliquid ipsam nisi, culpa quae, magnam dolores cupiditate velit exercitationem ratione deleniti dignissimos labore quia esse ea quos consequuntur perferendis aliquam. Est assumenda doloremque nobis, tenetur fuga similique eligendi nihil non officia possimus aliquid animi nisi ipsum qui veritatis repellat harum accusamus odit iusto laudantium voluptatum ipsa ut fugit veniam. Voluptates sint molestiae officia consequuntur iure repudiandae autem reiciendis, perspiciatis veritatis soluta quia velit necessitatibus.</p>                

                <div id="bt"><button>Read More...</button></div>
            </div>
        </div>
      </div>
      <!-- about -->


      <!-- contact  -->
      <div class="container" id="contact"    data-aos="fade-up"
      data-aos-duration="1500">
        <h1>CONTACT US</h1>
        <div class="row">
            <div class="col-md-4 py-1 py-md-0">
                <div class="form-group">
                    <input type="text" class="form-control" id="usr" placeholder="Name">
                </div>
            </div>
            <div class="col-md-4 py-1 py-md-0">
                <div class="form-group">
                    <input type="email" class="form-control" id="eml" placeholder="Email">
                </div>
            </div>
            <div class="col-md-4 py-1 py-md-0">
                <div class="form-group">
                    <input type="number" class="form-control" id="phn" placeholder="Phone">
                </div>
            </div>
            
        </div>
        <div class="form-group">
            <textarea class="form-control" rows="5" id="comment" placeholder="Message"></textarea>
        </div>
        <div id="messagebtn"><button>Send Message</button></div>
      </div>
      <!-- contact end -->


      <!-- footer -->
      <div id="footer"></div>

      <a href="#" class="arrow"><i><img src="./image/up-arrow.png" alt="" width="50px"></i></a>



    </div>





    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init();
      </script>
</body>
</html>