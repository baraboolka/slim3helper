document.addEventListener("DOMContentLoaded", function(){
    /* count subcategories for each category in menu */
    const menuCategories = document.querySelectorAll(".content-list-row");

    if(menuCategories){
        for(let menuCategory of menuCategories){
            let menuSubCategories = menuCategory.querySelectorAll(".content-list-row");
            let menuSubCategoriesCounter = menuCategory.querySelector(".content-list-row-more");

            if(menuSubCategoriesCounter){
                if(menuSubCategories.length > 0){
                    menuSubCategoriesCounter.innerHTML = "(" + menuSubCategories.length + ")";
                    menuSubCategoriesCounter.classList.add("show");

                    /* open|hide subcategories */
                    menuSubCategoriesCounter.addEventListener("click", function(){
                        menuSubCategoriesCounter.classList.toggle("arrow-up");
                        let menuSubCategoriesContainer = document.querySelector("#content-list-row-sub-" + menuSubCategoriesCounter.dataset.id);
                        menuSubCategoriesContainer.classList.toggle("open");
                    });
                }
            }
        }
    }

    /* open parent categories for active category in menu */
    const pathway = document.querySelectorAll("#content-pathway a");

    if(pathway){
        let pathUls = new Array();;
    
        for (let item of pathway) {
            pathUls.push(item.getAttribute("href"));
        }
        
        const menuTitles = document.querySelectorAll(".content-list-row-title a");

        if(menuTitles){
            for (let menuTitle of menuTitles){
                if(pathUls.includes(menuTitle.getAttribute("href"))){
                    let parentContainer = menuTitle.closest(".content-list-row-sub");

                    if(parentContainer){
                        parentContainer.classList.add("open");
                        parentContainer.closest(".content-list-row").querySelector(".content-list-row-more").classList.add("arrow-up");
                    }
                }
            }
        }
    }   
})