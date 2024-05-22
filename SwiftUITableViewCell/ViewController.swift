import UIKit
import SwiftUI

final class ViewController: UIViewController {

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.dataSource = self
        tableView.register(HostingTableViewCell<MyCellView>.self, forCellReuseIdentifier: "textCell")
        tableView.separatorStyle = .none
    }

    func tapAction() {
        print("hello from \(#function)")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textCell") as! HostingTableViewCell<MyCellView>
        cell.host(
            MyCellView(
                titleString: "Lorem Ipsum",
                subtitleString: "Dolor Sit Amet",
                bodyString: "Aliquam dui libero, viverra non est euismod, porta suscipit neque. Morbi non elementum ipsum. Donec quis lectus pharetra, pretium dui eu, porttitor turpis.",
                buttonString: "Change Status",
                onTapGestureCallback: tapAction,
                numberLockStatus: true
            ),
            parent: self
        )
        return cell
    }
}

struct MyCellView: View {
    let titleString: String
    let subtitleString: String
    let bodyString: String
    let buttonString: String
    let onTapGestureCallback: () -> Void
    let numberLockStatus: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(titleString)
                .font(.body)
                .foregroundStyle(.gray)
            HStack {
                Circle()
                    .fill(numberLockStatus ? .green : .gray)
                    .frame(width: 16, height: 16)
                Text(subtitleString)
                    .font(.headline)
            }
            Text(bodyString)
                .font(.body)
            Spacer()
            Divider()
            Spacer()
            Button(buttonString, action: onTapGestureCallback)
        }
        .padding()
    }
}

struct MyCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MyCellView(
                titleString: "Lorem Ipsum",
                subtitleString: "Dolor Sit Amet",
                bodyString: "Aliquam dui libero, viverra non est euismod, porta suscipit neque. Morbi non elementum ipsum. Donec quis lectus pharetra, pretium dui eu, porttitor turpis.",
                buttonString: "Call to Action",
                onTapGestureCallback: { },
                numberLockStatus: true
            )

            MyCellView(
                titleString: "Foo",
                subtitleString: "Bar",
                bodyString: "Baz",
                buttonString: "Call to Action",
                onTapGestureCallback: { },
                numberLockStatus: false
            )

        }
    }
}

// Source: https://stackoverflow.com/a/59474133/1004227

final class HostingTableViewCell<Content: View>: UITableViewCell {
    private weak var controller: UIHostingController<Content>?

    func host(_ view: Content, parent: UIViewController) {
        if let controller = controller {
            controller.rootView = view
            controller.view.layoutIfNeeded()
        } else {
            let swiftUICellViewController = UIHostingController(rootView: view)
            controller = swiftUICellViewController
            swiftUICellViewController.view.backgroundColor = .clear

            layoutIfNeeded()

            parent.addChild(swiftUICellViewController)
            contentView.addSubview(swiftUICellViewController.view)
            swiftUICellViewController.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addConstraint(NSLayoutConstraint(item: swiftUICellViewController.view!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
            contentView.addConstraint(NSLayoutConstraint(item: swiftUICellViewController.view!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
            contentView.addConstraint(NSLayoutConstraint(item: swiftUICellViewController.view!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
            contentView.addConstraint(NSLayoutConstraint(item: swiftUICellViewController.view!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))

            swiftUICellViewController.didMove(toParent: parent)
            swiftUICellViewController.view.layoutIfNeeded()
        }
    }
}
