import React from "react";
import ReactDOM from "react-dom";
import { Controller, useFieldArray, useForm } from "react-hook-form";
import "./styles.css";

let renderCount = 0;

function App() {
  const { register, control, handleSubmit, reset, watch } = useForm({
    defaultValues: {
      test: [{ firstName: "Bill", lastName: "Luo" }],
    },
  });
  const { fields, append, prepend, remove, swap, move, insert } = useFieldArray(
    {
      control,
      name: "test",
    }
  );

  const onSubmit = (data) => console.log("data", data);

  // if you want to control your fields with watch
  const watchResult = watch("test");
  console.log("watching", watchResult);

  renderCount++;

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <h1>Field Array </h1>
      <p>The following demo allow you to delete, append, prepend items</p>
      <span className="counter">Render Count: {renderCount}</span>
      <ul>
        {fields.map((item, index) => {
          return (
            <li key={item.id}>
              <input
                name={`test[${index}].firstName`}
                defaultValue={`${item.firstName}`} // make sure to set up defaultValue
                ref={register()}
              />
              <Controller
                as={<input />}
                name={`test[${index}].lastName`}
                control={control}
                defaultValue={item.lastName} // make sure to set up defaultValue
              />
              <button type="button" onClick={() => remove(index)}>
                Delete
              </button>
            </li>
          );
        })}
      </ul>
      <section>
        <button
          type="button"
          onClick={() => {
            append({ firstName: "appendBill", lastName: "appendLuo" });
          }}
        >
          append
        </button>
        <button
          type="button"
          onClick={() =>
            prepend({
              firstName: "prependFirstName",
              lastName: "prependLastName",
            })
          }
        >
          prepend
        </button>
        <button
          type="button"
          onClick={() =>
            insert(parseInt(2, 10), {
              firstName: "insertFirstName",
              lastName: "insertLastName",
            })
          }
        >
          insert at
        </button>

        <button type="button" onClick={() => swap(1, 2)}>
          swap
        </button>

        <button type="button" onClick={() => move(1, 2)}>
          move
        </button>

        <button type="button" onClick={() => remove(1)}>
          remove at
        </button>

        <button
          type="button"
          onClick={() =>
            reset({
              test: [{ firstName: "Bill", lastName: "Luo" }],
            })
          }
        >
          reset
        </button>
      </section>

      <input type="submit" />
    </form>
  );
}

const rootElement = document.getElementById("root");
ReactDOM.render(<App />, rootElement);
