import { render, screen, fireEvent } from "@testing-library/react";
import Button from "../../components/Button";

test("Button click updates text", () => {
  render(<Button />);
  const button = screen.getByText("Click Me");
  fireEvent.click(button);
  expect(screen.getByText("Clicked!")).toBeInTheDocument();
});
