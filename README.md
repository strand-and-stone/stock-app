# stocks-app

* How to build
The main `stocks-app` target should build and run within Xcode onto a simulator without any prerequisite steps. The Swift packages are contained with the Xcode project and should all be accessibile relative in folder structure to the main app.


1. Separation of Concerns
There are two Swift packages (`cash-data-package` and `cash-network-package`) included within this project to cleanly organize different parts of the codebase.

The data package is responsible for defining the Stock data model and several helper functions used by the app to format data. It also serves as an entry point for the main app to retrieve Portfolio-related data - this structure allows us to scale the `StockManager` class to add data persistance and long-term storage of Stock data between app sessions in an organized location, if we wanted to.

The network package is responsible for defining the core networking layer (built upon `URLSession` for now - in `StockFetcher`) where we make our network requests and handle their responses. It also defines a router (`StockRouter`) that we can extend in the future to add more network requests to different routes.

2. UI Construction
The UI for this app is built with both Storyboard and programmatically - the intention was to show the pros and cons to each style. It was quick to build the main tableView and `StockCell` on the Storyboard with InterfaceBuilder; extra boiler plate code around tableView initialization and cell registration was avoided. For other parts of the app, such as the `ErrorView`, the `StockHeader` and `StockerFooter` views, the UI was built programmatically. The benefits to this approach are that the view files are succinct and well-organized; subviews are lazily initialized and their properties can be modified quickly between builds without having to fine-tune things on Storyboard.

The `ErrorView` handles the two main error cases described in the project prompt - empty response and malformed data - but can be extended to handle other cases as well, such as no network connectivity, or authentication errors. There is a retry button and delegate function to allow the `ViewController` to re-attempt the network request to fetch a user's portfolio.

The `StockHeader` and `StockFooter` views are sticky to the top and bottom of the tableView. TThey provide additional information to the user on the contents shown in the tableView. The footer shows a "Prices current as of" timestamp that is built using the oldest `current_price_timestamp` found within the Stocks payload. The The tableView also has a pull-to-refresh function to fetch new Portfolio data and then reload the tableView.

3. Third-Party Libraries
None used. The networking layer was built upon `URLSession` and the views were constructed entirely with native iOS view elements.

