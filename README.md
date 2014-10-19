Sample ADT Hook
=======

This Liferay Hook adds a set of sample Application Display Templates to the Global site of your Liferay Portal installation.

Included samples are:

* **Albums Grid:** Displays albums as a grid with their cover and artist. Requires Jukebox Portlet.
* **Artist Grid:** Displays artists as a grid with their picture and albums. Requires Jukebox Portlet.
* **Blogs with Avatar:** Displays a list of blogs with an image, a summary and the user's avatar.
* **Blogs with Avatar in 2 Columns:** Displays a list of blogs with an image, a summary and the user's avatar in a 2 column layout.
* **Bars Chart:** Displays content ratings as a bars chart.
* **Columns Chart:** Displays content ratings as a column chart.
* **Responsive Media Gallery:** Displays a media gallery responsive to changes in layout.
* **Basic List:** Displays a basic list with numbered items.
* **Basic List with Ratings:** Displays a basic list with numbered items and ratings.
* **Basic List with Swipe Effect:** Displays a basic list with numbered items and ratings. In mobile devices, the edit control is displayed on a swipe event.
* **Enhanced List:** Displays a numbered list with an image, a title and a summary of the content.
* **Enhanced List with Bars:** Displays a numbered list with an image, a title and a summary of the content in the List tab and content ratings as a bars chart in the Chart tab.
* **Map:** Displays content on a Map. Clicking on a marker displays a summary of the content.
* **Tags Pie Chart:** Displays the tag frequency as a pie chart.

## Installation

Read [Liferay User's Guide](https://www.liferay.com/es/documentation/liferay-portal/6.2/development/-/ai/customize-and-extend-functionality-hooks-liferay-portal-6-2-dev-guide-en) to find out how to deploy Hook projects.

## Requirements

To deploy this hook the Liferay Jukebox Portlet must have been previously installed in Liferay. Alternatively, you can remove the Jukebox samples from the `templates/portlet-display-templates.xml` file and the delete the `required-deployment-contexts` line from the liferay-plugin-package.properties file.
