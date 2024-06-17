import Section from "./Section"
const Footer = () => {
  return (
    <Section crosses className="!px-0 !py-10">
      <div className="container flex sm:justify-between justify-center items-center gap-10 max-sm:flex-col">
        <p className="caption text-violet-300 lg:block">{new Date().getFullYear()}.</p>
        <p className="caption text-emerald-300 lg:block">Project Team Members : <i>Santanu Layek, Gauransh Sharma, Vihan Aggarwal, Adhiraj Singh Chauhan</i></p>
      </div>
    </Section>
  )
}

export default Footer
